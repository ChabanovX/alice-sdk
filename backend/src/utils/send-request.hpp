#pragma once

#include <string>
#include <userver/components/component_context.hpp>

namespace voice_assistant::utils {

std::string SendHttpRequest(const userver::components::ComponentContext& component_context,
                            const char* url,
                            const std::string& body);

}  // namespace voice_assistant::utils
