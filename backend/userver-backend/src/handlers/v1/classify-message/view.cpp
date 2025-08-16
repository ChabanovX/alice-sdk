#include "view.hpp"

#include <userver/clients/http/component.hpp>
#include <userver/components/component_context.hpp>
#include <userver/formats/json.hpp>
#include <userver/server/handlers/http_handler_base.hpp>
#include <userver/utils/assert.hpp>
#include <userver/yaml_config/merge_schemas.hpp>

#include "../../../integrations/analytics-service/analytics-client.hpp"

namespace voice_assistant::classifier {

namespace {

class ClassifyMessage final : public userver::server::handlers::HttpHandlerBase {
   public:
    static constexpr std::string_view kName = "handler-v1-classify-message";  // NOLINT(*unused*)

    ClassifyMessage(const userver::components::ComponentConfig& config,
                    const userver::components::ComponentContext& context)
        : HttpHandlerBase(config, context),
          analytics_client_(context.FindComponent<analytics_service::AnalyticsClient>()) {}

    std::string HandleRequestThrow(const userver::server::http::HttpRequest& request,
                                   userver::server::request::RequestContext& /*context*/) const override {
        const auto& body = request.RequestBody();
        auto& response = request.GetHttpResponse();

        if (request.RequestBody().empty()) {
            response.SetStatus(userver::server::http::HttpStatus::kBadRequest);
            return "Request body is empty!";
        }

        const auto json = userver::formats::json::FromString(body);

        if (!json.HasMember("text")) {
            response.SetStatus(userver::server::http::HttpStatus::kBadRequest);
            return "No member text in json!";
        }

        try {
            auto cluster_body = analytics_client_.SendHttpRequest(body);

            const auto out_json = userver::formats::json::FromString(cluster_body);

            return cluster_body;
        } catch (const std::exception& e) {
            response.SetStatus(userver::server::http::HttpStatus::kBadGateway);
            return std::string("Cluster service error: ") + e.what();
        }
    }

   private:
    const analytics_service::AnalyticsClient& analytics_client_;
};

}  // namespace

void AppendClassifyMessage(userver::components::ComponentList& component_list) {
    component_list.Append<ClassifyMessage>();
}

}  // namespace voice_assistant::classifier
