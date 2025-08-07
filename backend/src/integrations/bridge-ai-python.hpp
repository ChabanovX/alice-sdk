#pragma once

#include <userver/components/component_context.hpp>

namespace voice_assistant::bridges::ai_python {

std::string ClassifyMessageWithAI(const userver::components::ComponentContext& component_context,
                                  const std::string& raw_text);

}  // namespace voice_assistant::bridges::ai_python
