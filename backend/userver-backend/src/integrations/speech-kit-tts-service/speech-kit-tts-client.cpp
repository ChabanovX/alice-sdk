#include <stdexcept>
#include <string>
#include <userver/clients/http/client.hpp>
#include <userver/clients/http/component.hpp>
#include <userver/components/component_base.hpp>
#include <userver/components/component_context.hpp>
#include <userver/components/component_list.hpp>
#include <userver/logging/log.hpp>
#include <userver/yaml_config/merge_schemas.hpp>
#include <userver/clients/http/streamed_response.hpp>
#include <userver/server/http/http_status.hpp>
#include <userver/server/websocket/server.hpp>
#include <userver/server/websocket/websocket_handler.hpp>

#include "speech-kit-tts-client.hpp"

namespace voice_assistant::speechkit_tts_service {

SpeechKitTTSClient::SpeechKitTTSClient(const userver::components::ComponentConfig& config,
                                 const userver::components::ComponentContext& context)
    : ComponentBase{config, context},
      service_url_(config["speech-kit-tts-service-url"].As<std::string>()),
      http_client_(context.FindComponent<userver::components::HttpClient>().GetHttpClient()) {}

void SpeechKitTTSClient::SendHttpRequest(userver::server::websocket::WebSocketConnection& ws, std::string& text) const {
    const char* token_ptr = std::getenv("IAM_TOKEN");
    const char* folder_ptr = std::getenv("FOLDER_ID");
    if (!token_ptr) {
        LOG_ERROR() << "IAM_TOKEN not set";
        ws.Close(userver::server::websocket::CloseStatus::kServerError);
        return;
    }
    if (!folder_ptr) {
        LOG_ERROR() << "FOLDER_ID not set";
        ws.Close(userver::server::websocket::CloseStatus::kServerError);
        return;
    }
    std::string iam_token{token_ptr};
    std::string folder_id{folder_ptr};


    std::string post_body = "text=" + text + "&lang=ru-RU&voice=alena&folderId=" + folder_id;
    userver::clients::http::Headers headers = {
        {"Authorization", "Bearer " + iam_token}
    };

    auto queue = userver::concurrent::StringStreamQueue::Create();
    auto streamed_response = http_client_.CreateRequest().post(service_url_).headers(headers).data(post_body).async_perform_stream_body(queue);
    std::string chunk;
    try {
        while (streamed_response.ReadChunk(chunk, userver::engine::Deadline::FromDuration(std::chrono::seconds(60)))) {
            userver::server::websocket::Message msg{.data = chunk};
            ws.Send(msg);
        }
    } catch (const std::exception& e) {
        LOG_ERROR() << "Error reading streamed_response: " << e.what();
        ws.Close(userver::server::websocket::CloseStatus::kServerError);
        return;
    }

    auto status_code = streamed_response.StatusCode();
    if (status_code != userver::server::http::HttpStatus::kOk) {
        LOG_ERROR() << "Downstream returned non-OK status: " << static_cast<int>(status_code);
        ws.Close(userver::server::websocket::CloseStatus::kServerError);
        return;
    }
}

userver::yaml_config::Schema SpeechKitTTSClient::GetStaticConfigSchema() {
    return userver::yaml_config::MergeSchemas<userver::components::ComponentBase>(R"(
type: object
description: My dependencies schema
additionalProperties: false
properties:
    speech-kit-tts-service-url:
        type: string
        description: URL of the cpeech-kit-tts server
)");
}

void AppendSpeechKitTTSClient(userver::components::ComponentList& component_list) {
    component_list.Append<SpeechKitTTSClient>();
}

}  // namespace voice_assistant::speechkit_tts_service
