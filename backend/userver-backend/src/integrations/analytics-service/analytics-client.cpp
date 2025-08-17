#include <stdexcept>
#include <string_view>

#include <userver/clients/http/client.hpp>
#include <userver/clients/http/component.hpp>
#include <userver/components/component_base.hpp>
#include <userver/components/component_context.hpp>
#include <userver/components/component_list.hpp>
#include <userver/formats/json/serialize.hpp>
#include <userver/formats/json/value_builder.hpp>
#include <userver/yaml_config/merge_schemas.hpp>

#include "analytics-client.hpp"

namespace voice_assistant::analytics_service {

AnalyticsClient::AnalyticsClient(const userver::components::ComponentConfig& config,
                                 const userver::components::ComponentContext& context)
    : ComponentBase{config, context},
      service_url_(config["analytics-url"].As<std::string>()),
      service_url_with_type_(config["analytics-url-with-type"].As<std::string>()),
      http_client_(context.FindComponent<userver::components::HttpClient>().GetHttpClient()) {}

std::string AnalyticsClient::SendHttpRequest(std::string_view text) const {
    userver::clients::http::Headers headers = {{"Content-Type", "application/json"}};
    userver::formats::json::ValueBuilder json;
    json["text"] = text;
    auto response = http_client_.CreateRequest()
                        .post(service_url_)
                        .headers(headers)
                        .data(userver::formats::json::ToString(json.ExtractValue()))
                        .perform();

    if (response->IsError()) {
        throw std::logic_error("Analytics service gived an error: \n" + response->body());
    }

    return std::move(*response).body();
}

std::string AnalyticsClient::SendHttpRequestWithType(std::string_view text, std::string_view request_type) const {
    userver::clients::http::Headers headers = {{"Content-Type", "application/json"}};
    userver::formats::json::ValueBuilder json;
    json["text"] = text;
    json["request_type"] = request_type;
    auto response = http_client_.CreateRequest()
                        .post(service_url_with_type_)
                        .headers(headers)
                        .data(userver::formats::json::ToString(json.ExtractValue()))
                        .perform();

    if (response->IsError()) {
        throw std::logic_error("Analytics service gived an error: \n" + response->body());
    }

    return std::move(*response).body();
}

userver::yaml_config::Schema AnalyticsClient::GetStaticConfigSchema() {
    return userver::yaml_config::MergeSchemas<userver::components::ComponentBase>(R"(
type: object
description: My dependencies schema
additionalProperties: false
properties:
    analytics-url:
        type: string
        description: URL of the endpoint where type is to be deduced
    analytics-url-with-type:
        type: string
        description: URL of the endpoint where type can be specified
)");
}

void AppendAnalyticsService(userver::components::ComponentList& component_list) {
    component_list.Append<AnalyticsClient>();
}

}  // namespace voice_assistant::analytics_service
