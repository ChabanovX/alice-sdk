#pragma once

#include <userver/components/component_context.hpp>
#include <string>

std::string SendHttpRequest(const userver::components::ComponentContext& component_context,
                             const char* url, const std::string& body);

const char* getenvWithError(const char* key) noexcept(false);