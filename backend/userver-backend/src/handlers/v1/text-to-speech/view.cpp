#include "view.hpp"

#include <userver/server/websocket/server.hpp>
#include <userver/server/websocket/websocket_handler.hpp>
#include <string>

#include "../../../integrations/speech-kit-tts-service/speech-kit-tts-client.hpp"

namespace voice_assistant::websocket_tts {

namespace {

class TextHandler final : public userver::server::websocket::WebsocketHandlerBase {
public:
    static constexpr std::string_view kName = "handler-v1-text-to-speech";
 
    TextHandler(const userver::components::ComponentConfig& config,
                  const userver::components::ComponentContext& context)
      : WebsocketHandlerBase(config, context),
        speechkit_tts_service_(context.FindComponent<speechkit_tts_service::SpeechKitTTSClient>()) {}
 
    void Handle(userver::server::websocket::WebSocketConnection& ws, userver::server::request::RequestContext& /*unused*/) const override {
        userver::server::websocket::Message msg;
        ws.Recv(msg);
        std::string resp;
        speechkit_tts_service_.SendHttpRequest(ws, msg.data);
        ws.Close(userver::server::websocket::CloseStatus::kNormal);
    }
private:
    const speechkit_tts_service::SpeechKitTTSClient& speechkit_tts_service_;
};

} // namespace 

void AppendTextHandler(userver::components::ComponentList& component_list) {
    component_list.Append<TextHandler>();
}

} // namespace voice_assistant::websocket::voice