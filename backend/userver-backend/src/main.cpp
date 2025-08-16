#include <userver/clients/dns/component.hpp>
#include <userver/clients/http/component.hpp>
#include <userver/components/minimal_server_component_list.hpp>
#include <userver/server/handlers/ping.hpp>
#include <userver/server/handlers/tests_control.hpp>
#include <userver/storages/postgres/component.hpp>
#include <userver/testsuite/testsuite_support.hpp>

#include <userver/utils/daemon_run.hpp>

#include "handlers/v1/classify-message/view.hpp"
#include "integrations/analytics-service/analytics-client.hpp"
#include "handlers/v1/text-to-speech/view.hpp"
#include "integrations/speech-kit-tts-service/speech-kit-tts-client.hpp"

int main(int argc, char* argv[]) {
    using namespace voice_assistant;

    auto component_list = userver::components::MinimalServerComponentList()
                              .Append<userver::server::handlers::Ping>()
                              .Append<userver::components::HttpClient>()
                              .Append<userver::clients::dns::Component>()
                              .Append<userver::components::TestsuiteSupport>()
                              .Append<userver::server::handlers::TestsControl>()
                              /*.Append<userver::components::Postgres>("postgres-db-1")*/;

    classifier::AppendClassifyMessage(component_list);
    analytics_service::AppendAnalyticsService(component_list);
    text_to_speech::AppendTextToSpeech(component_list);
    speechkit_tts_service::AppendSpeechKitTTSClient(component_list);

    return userver::utils::DaemonMain(argc, argv, component_list);
}
