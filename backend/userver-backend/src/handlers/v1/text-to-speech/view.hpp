#pragma once

#include <userver/components/component_list.hpp>

namespace voice_assistant::text_to_speech {

void AppendTextToSpeech(userver::components::ComponentList& component_list);

}  // namespace voice_assistant::text_to_speech
