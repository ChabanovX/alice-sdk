#pragma once

#include <userver/components/component_list.hpp>

namespace voice_assistant::websocket_tts {

void AppendTextHandler(userver::components::ComponentList& component_list);

}  // namespace voice_assistant::websocket_tts