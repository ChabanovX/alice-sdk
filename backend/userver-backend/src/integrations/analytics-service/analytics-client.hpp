#pragma once

#include <string>
#include <string_view>

#include <userver/clients/http/client.hpp>
#include <userver/clients/http/component.hpp>
#include <userver/components/component_base.hpp>
#include <userver/components/component_context.hpp>
#include <userver/components/component_list.hpp>
#include <userver/yaml_config/merge_schemas.hpp>

namespace voice_assistant::analytics_service {

class AnalyticsClient : public userver::components::ComponentBase {
   public:
    static constexpr std::string_view kName = "analytics-client";

    AnalyticsClient(const userver::components::ComponentConfig& config,
                    const userver::components::ComponentContext& context);

    [[nodiscard]] std::string SendHttpRequest(std::string_view text) const;
    [[nodiscard]] std::string SendHttpRequestWithType(std::string_view text, std::string_view request_type) const;

    static userver::yaml_config::Schema GetStaticConfigSchema();

   private:
    const std::string service_url_;
    const std::string service_url_with_type_;
    userver::clients::http::Client& http_client_;
};

void AppendAnalyticsService(userver::components::ComponentList& component_list);

}  // namespace voice_assistant::analytics_service
