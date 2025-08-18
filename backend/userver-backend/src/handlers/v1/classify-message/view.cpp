#include "view.hpp"

#include "classifier/classifier.hpp"
#include "classifier/classifier_fabric.hpp"
#include "classifier/string_converter.hpp"
#include "db/metrics/models.hpp"
// #include "db/metrics/repository.hpp"
// #include "db/voice_statistics/repository.hpp"
#include "integrations/analytics-service/analytics-client.hpp"
#include "models/scenarios.hpp"

#include <boost/range/algorithm/find.hpp>
#include <userver/components/component_context.hpp>
#include <userver/formats/json/exception.hpp>
#include <userver/formats/json/serialize.hpp>
#include <userver/formats/json/value.hpp>
#include <userver/formats/json/value_builder.hpp>
#include <userver/formats/parse/to.hpp>
#include <userver/formats/serialize/common_containers.hpp>
#include <userver/formats/serialize/to.hpp>
#include <userver/server/handlers/http_handler_base.hpp>
#include <userver/server/http/http_status.hpp>
#include <userver/storages/postgres/component.hpp>
#include <userver/utils/datetime_light.hpp>

#include <cctype>
#include <chrono>
#include <cstddef>
#include <optional>
#include <string>
#include <string_view>
#include <vector>

namespace voice_assistant::classifier {

namespace {

constexpr userver::utils::TrivialBiMap request_names = [](auto selector) {  // NOLINT(*unused*)
    return selector()
        .Case("accept", TypeRequest::ACCEPT_ORDER)
        .Case("decline", TypeRequest::CANCEL_ORDER)
        .Case("read_passenger_message", TypeRequest::VOICE_MESSAGE)
        .Case("read_passenger_preferences", TypeRequest::VOICE_WISH)
        .Case("call_passenger", TypeRequest::CALL_PASSENGER)
        .Case("route", TypeRequest::CREATE_ROUTE)
        .Case("route_choice", TypeRequest::CHOOSE_ROUTE)
        .Case("business", TypeRequest::BUSINESS)
        .Case("home", TypeRequest::HOME)
        .Case("find_nearby_places", TypeRequest::FIND)
        .Case("tariff_change", TypeRequest::CHANGE_FARE)
        .Case("other", TypeRequest::OTHER);
};

struct Body {
    std::string user_id;
    std::chrono::system_clock::time_point voice_start_time;
    std::string request_text;
    std::string context_token;

    friend Body Parse(const userver::formats::json::Value& json, userver::formats::parse::To<Body> /*tag*/) {
        return {
            json["user_id"].As<decltype(user_id)>(),
            json["voice_start_time"].As<decltype(voice_start_time)>(),
            json["request_text"].As<decltype(request_text)>(),
            "token_stub",
        };
    }
};

struct Response {
    std::string intention;
    std::optional<std::string> addresses;
    std::optional<std::vector<int>> route_choice;
    std::optional<std::string> tariff;
    std::optional<std::vector<std::string>> places;

    friend Response Parse(const userver::formats::json::Value& json, userver::formats::parse::To<Response> /*tag*/) {
        return {
            json["intention"].As<decltype(intention)>(),
            json["addresses"].As<decltype(addresses)>(),
            json["route_choice"].As<decltype(route_choice)>(),
            json["tariff"].As<decltype(tariff)>(),
            json["places"].As<decltype(places)>(),
        };
    }

    friend userver::formats::json::Value Serialize(  // NOLINT(*unused*)
        const Response& response,
        userver::formats::serialize::To<userver::formats::json::Value> /*tag*/) {
        userver::formats::json::ValueBuilder json;
        json["intention"] = response.intention;
        json["addresses"] = response.addresses;
        json["route_choice"] = response.route_choice;
        json["tariff"] = response.tariff;
        json["places"] = response.places;
        return json.ExtractValue();
    }
};

constexpr auto kRequestTypesWithParams = {
    TypeRequest::CREATE_ROUTE,
    TypeRequest::CHOOSE_ROUTE,
    TypeRequest::BUSINESS,
    TypeRequest::FIND,
    TypeRequest::CHANGE_FARE,
};

class ClassifyMessage final : public userver::server::handlers::HttpHandlerBase {
   public:
    static constexpr std::string_view kName = "handler-v1-classify-message";  // NOLINT(*unused*)

    ClassifyMessage(const userver::components::ComponentConfig& config,
                    const userver::components::ComponentContext& context)
        : HttpHandlerBase(config, context),
          analytics_client_(context.FindComponent<analytics_service::AnalyticsClient>()),
        //   metrics_repo_{context.FindComponent<userver::components::Postgres>("postgres-db-1").GetCluster()},
        //   statistics_repo_{context.FindComponent<userver::components::Postgres>("postgres-db-1").GetCluster()},
          local_classifier_{CreateClassifierFromSave()} {}

    // void UpdateMetrics(const Body& body, TypeRequest request_type) const {
    //     auto now = userver::utils::datetime::Now();
    //     double duration = std::chrono::duration<double>{now - body.voice_start_time}.count();
    //     metrics_repo_.RegisterRequest(body.user_id, body.user_id, request_type, now, duration);

    //     auto last_request = metrics_repo_.GetLastRequest(body.user_id);
    //     if (last_request && last_request->type == request_type && request_type != TypeRequest::OTHER) {
    //         metrics_repo_.IncrementCounter(db::metrics::CounterCategory::kRepetitions);
    //     }

    //     // Find the best condition from analytics
    //     // if (request_type == TypeRequest::OTHER) {
    //     //     metrics_repo_.IncrementCounter(db::metrics::CounterCategory::kFallbacks);
    //     // }

    //     // Find a way to detect cancellations
    //     // if (request_type == TypeRequest::OTHER) {
    //     //     metrics_repo_.IncrementCounter(db::metrics::CounterCategory::kCancellations);
    //     // }
    // }

    // void UpdateWordStatistics(std::string_view text, TypeRequest request_type) const {
    //     if (request_type == TypeRequest::OTHER) return;
    //     std::vector<std::string> words;
    //     for (std::size_t start = 0, i = 0; i <= text.size(); ++i) {
    //         if (i == text.size() || std::ispunct(text[i]) != 0 || std::isspace(text[i]) != 0) {
    //             if (start != i) {
    //                 words.emplace_back(text.substr(start, i - start));
    //             }
    //             start = i + 1;
    //         }
    //     }
    //     statistics_repo_.UpdateStatistics(request_type, words);
    // }

    std::string HandleRequestThrow(const userver::server::http::HttpRequest& request,
                                   userver::server::request::RequestContext& /*context*/) const override {
        auto& response = request.GetHttpResponse();

        // Parse input
        Body body;
        try {
            const auto& raw_body = request.RequestBody();
            auto json = userver::formats::json::FromString(raw_body);
            body = json.As<Body>();
        } catch (userver::formats::json::Exception& e) {
            response.SetStatus(userver::server::http::HttpStatus::kBadRequest);
            return std::string{e.GetMessage()};
        } catch (userver::utils::datetime::DateParseError& e) {
            response.SetStatus(userver::server::http::HttpStatus::kBadRequest);
            return std::string{e.what()};
        }

        // Local decision
        auto local_decision = local_classifier_.GetTypeRequest(utf8ToUtf32(body.request_text));
        // If can respond early
        if (local_decision && *local_decision != TypeRequest::OTHER &&
            boost::range::find(kRequestTypesWithParams, *local_decision) == kRequestTypesWithParams.end()) {
            Response response{};

            auto request_name = request_names.TryFind(*local_decision);
            response.intention = request_name ? *request_name : "";

            // UpdateMetrics(body, *local_decision);
            // UpdateWordStatistics(body.request_text, *local_decision);

            userver::formats::json::ValueBuilder json{response};
            return userver::formats::json::ToString(json.ExtractValue());
        }

        // Call master classifier
        try {
            auto cluster_body = analytics_client_.SendHttpRequest(body.request_text);
            auto response = userver::formats::json::FromString(cluster_body).As<Response>();
            auto request_type = request_names.TryFindByFirst(response.intention);
            if (!request_type) {
                throw std::runtime_error{"Unknown request_type"};
            }

            // UpdateMetrics(body, *request_type);
            // UpdateWordStatistics(body.request_text, *request_type);

            return cluster_body;
        } catch (const std::exception& e) {
            response.SetStatus(userver::server::http::HttpStatus::kBadGateway);
            return std::string("Cluster service error: ") + e.what();
        }
    }

   private:
    const analytics_service::AnalyticsClient& analytics_client_;
    // db::metrics::Repository metrics_repo_;
    // db::voice_statistics::Repository statistics_repo_;
    Classifier local_classifier_;
};

}  // namespace

void AppendClassifyMessage(userver::components::ComponentList& component_list) {
    component_list.Append<ClassifyMessage>();
}

}  // namespace voice_assistant::classifier
