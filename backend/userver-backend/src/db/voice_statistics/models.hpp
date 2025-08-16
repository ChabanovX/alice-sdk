#pragma once

#include "models/scenarios.hpp"

#include <cstddef>
#include <unordered_map>

namespace voice_assistant::db::voice_statistics {

struct WordStatistics {
    std::size_t used_in_types_count;
    std::unordered_map<TypeRequest, std::size_t> count_by_request_type;
};

}  // namespace voice_assistant::db::voice_statistics
