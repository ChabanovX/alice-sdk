#pragma once

#include <string>
#include <string_view>

#include <userver/clients/http/client.hpp>
#include <userver/clients/http/component.hpp>
#include <userver/components/component_base.hpp>
#include <userver/components/component_context.hpp>
#include <userver/components/component_list.hpp>
#include <userver/yaml_config/merge_schemas.hpp>
#include <userver/server/websocket/server.hpp>
#include <userver/server/websocket/websocket_handler.hpp>

namespace voice_assistant::speechkit_tts_service {

class SpeechKitTTSClient : public userver::components::ComponentBase {
public:
    static constexpr std::string_view kName = "speech-kit-tts-client";

    SpeechKitTTSClient(const userver::components::ComponentConfig& config,
                    const userver::components::ComponentContext& context);

    void SendHttpRequest(userver::server::websocket::WebSocketConnection& ws, std::string& text) const;

    static userver::yaml_config::Schema GetStaticConfigSchema();

private:

    const std::string service_url_;
    userver::clients::http::Client& http_client_;
};

void AppendSpeechKitTTSClient(userver::components::ComponentList& component_list);

}  // namespace voice_assistant::speechkit_tts_service
