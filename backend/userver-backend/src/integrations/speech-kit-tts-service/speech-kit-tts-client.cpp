#include <stdexcept>
#include <userver/clients/http/client.hpp>
#include <userver/clients/http/component.hpp>
#include <userver/components/component_base.hpp>
#include <userver/components/component_context.hpp>
#include <userver/components/component_list.hpp>
#include <userver/yaml_config/merge_schemas.hpp>
#include <userver/clients/http/streamed_response.hpp>
#include <userver/yaml_config/merge_schemas.hpp>
#include <userver/server/http/http_status.hpp>

#include "speech-kit-tts-client.hpp"

namespace voice_assistant::speechkit_tts_service {

SpeechKitTTSClient::SpeechKitTTSClient(const userver::components::ComponentConfig& config,
                                 const userver::components::ComponentContext& context)
    : ComponentBase{config, context},
      service_url_(config["speech-kit-tts-service-url"].As<std::string>()),
      http_client_(context.FindComponent<userver::components::HttpClient>().GetHttpClient()) {}

std::string SpeechKitTTSClient::SendHttpRequest(const std::string& text) const {
    const std::string iam_token = "t1.9euelZqQzZSOnMfIko6UyJPHlpCXk-3rnpWakZjGzZnLzMaZzp3Ji5GZnIvl9PdPf306-e9PFXzv3fT3Dy57OvnvTxV8783n9euelZqWx56Pk8eYkMjGncqLnYqVyO_8xeuelZqWx56Pk8eYkMjGncqLnYqVyA.wvDHWz08rNO-Aw8jILeqr-7sZy5Wr-_i4VaxiLD7vO8GLypWRoW2mqKaDdwwRXV-gu0ZY2kytRpsl5O-3DY_DA";
    const std::string folder_id = "b1gis2g6g33ta8ki6dke";
    std::string post_body = std::string("text=") + text + "&lang=ru-RU&voice=filipp&folderId=" + folder_id;
    LOG_WARNING() << "text = " << text << '\n';
    //userver::clients::http::Headers headers = {{"Content-Type", "application/json"}, {"Authorization", "Bearer " + iam_token}};
    userver::clients::http::Headers headers = {{"Authorization", "Bearer " + iam_token}};
    auto queue = userver::concurrent::StringStreamQueue::Create();
    LOG_WARNING() << "post_body = " << post_body << '\n';
    auto streamed_response = http_client_.CreateRequest().post(service_url_).headers(headers).data(post_body).async_perform_stream_body(queue);
    //auto request = http_client_.CreateRequest().post().url(service_url_).timeout(std::chrono::seconds(60));
    std::string chunk;
    std::string body;
    try {
        while (streamed_response.ReadChunk(chunk, userver::engine::Deadline::FromDuration(std::chrono::seconds(60)))) {
            body.append(chunk);
        }
    } catch (const std::exception& e) {
        LOG_ERROR() << "Error reading streamed_response: " << e.what();
        // Можно вернуть пустую строку или бросить исключение; выберем пустую строку как индикатор ошибки
        return {};
    }

    auto status = streamed_response.StatusCode();
    if (status != userver::server::http::HttpStatus::kOk) {
        LOG_ERROR() << "Downstream returned non-OK status: " << static_cast<int>(status);
        // Вернём тело даже при ошибке, чтобы caller имел диагностическую информацию
        LOG_WARNING() << body << '\n';
        return body;
    }

    LOG_INFO() << "IsOk!" << '\n';
    return body;

    /*if (response->IsError()) {
        throw std::logic_error("Analytics service give error!");
    }

    return std::move(*response).body();*/
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
