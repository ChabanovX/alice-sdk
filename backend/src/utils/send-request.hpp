#pragma once

#include <string>
#include <userver/components/component_context.hpp>

std::string SendHttpRequest(const userver::components::ComponentContext& component_context,
                            const char* url,
                            const std::string& body);

const char* getenvWithError(const char* key) noexcept(false);
