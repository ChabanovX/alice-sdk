#pragma once

#include <userver/components/component_context.hpp>

std::string ClassifyMessageWithAI(const userver::components::ComponentContext& component_context,
                                  const std::string& raw_text);
