#include <stdexcept>
#include <userver/clients/http/client.hpp>
#include <userver/clients/http/component.hpp>
#include <userver/components/component_base.hpp>
#include <userver/components/component_context.hpp>
#include <userver/components/component_list.hpp>
#include <userver/yaml_config/merge_schemas.hpp>

#include "analytics-client.hpp"

namespace voice_assistant::analytics_service {

AnalyticsClient::AnalyticsClient(const userver::components::ComponentConfig& config,
                                 const userver::components::ComponentContext& context)
    : ComponentBase{config, context},
      service_url_(config["analytics-url"].As<std::string>()),
      http_client_(context.FindComponent<userver::components::HttpClient>().GetHttpClient()) {}

std::string AnalyticsClient::SendHttpRequest(const std::string& body) const {
    userver::clients::http::Headers headers = {{"Content-Type", "application/json"}};
    auto response = http_client_.CreateRequest().post(service_url_).headers(headers).data(body).perform();

    if (response->IsError()) {
        throw std::logic_error("Analytics service give error!");
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
        description: URL of the analytics-service
)");
}

void AppendAnalyticsService(userver::components::ComponentList& component_list) {
    component_list.Append<AnalyticsClient>();
}

}  // namespace voice_assistant::analytics_service
