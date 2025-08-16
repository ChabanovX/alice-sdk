#include "view.hpp"

#include <userver/clients/http/component.hpp>
#include <userver/components/component_context.hpp>
#include <userver/formats/json.hpp>
#include <userver/server/handlers/http_handler_base.hpp>
#include <userver/utils/assert.hpp>
#include <userver/yaml_config/merge_schemas.hpp>

#include "../../../integrations/speech-kit-tts-service/speech-kit-tts-client.hpp"

namespace voice_assistant::text_to_speech {

namespace {

class TextToSpeech final : public userver::server::handlers::HttpHandlerBase {
   public:
    static constexpr std::string_view kName = "handler-v1-text-to-speech";  // NOLINT(*unused*)

    TextToSpeech(const userver::components::ComponentConfig& config,
                    const userver::components::ComponentContext& context)
        : HttpHandlerBase(config, context),
        tts_client_(context.FindComponent<speechkit_tts_service::SpeechKitTTSClient>()) {} //???

    std::string HandleRequestThrow(const userver::server::http::HttpRequest& request,
                                   userver::server::request::RequestContext& /*context*/) const override {
        const auto& body = request.RequestBody();
        auto& response = request.GetHttpResponse();

        if (request.RequestBody().empty()) {
            response.SetStatus(userver::server::http::HttpStatus::kBadRequest);
            return "Request body is empty!";
        }

        const auto json = userver::formats::json::FromString(body);
        const auto text = json["text"].As<std::string>();
        if (!json.HasMember("text")) {
            response.SetStatus(userver::server::http::HttpStatus::kBadRequest);
            return "No member text in json!";
        }
        try {
            auto audio_data = tts_client_.SendHttpRequest(text);
            response.SetHeader(std::string("Content-Type"), std::string("audio/ogg; codecs=opus"));
            response.SetHeader(std::string("Content-Length"), std::to_string(audio_data.size()));
            return std::string{audio_data.data(), audio_data.size()};
            //return std::string(audio_data.begin(), audio_data.end());
        } catch (const std::exception& e) {
            response.SetStatus(userver::server::http::HttpStatus::kBadGateway);
            return std::string("Cluster service error: ") + e.what();
        }
    }

   private:
    const speechkit_tts_service::SpeechKitTTSClient& tts_client_;
};

}  // namespace

void AppendTextToSpeech(userver::components::ComponentList& component_list) {
    component_list.Append<TextToSpeech>();
}

}  // namespace voice_assistant::text_to_speech
