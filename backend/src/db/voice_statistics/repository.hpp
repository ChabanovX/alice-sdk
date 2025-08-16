#pragma once

#include "models.hpp"
#include "models/scenarios.hpp"

#include <userver/storages/postgres/postgres_fwd.hpp>

#include <cstddef>
#include <string>
#include <unordered_map>
#include <vector>

namespace voice_assistant::db::voice_statistics {

class Repository {
   public:
    explicit Repository(userver::storages::postgres::ClusterPtr db_cluster);

    [[nodiscard]] std::vector<std::string> GetStopWords() const;

    void UpdateStatistics(TypeRequest request_type, const std::vector<std::string>& words) const;

    [[nodiscard]] std::unordered_map<std::string, WordStatistics> GetStatistics(
        const std::vector<std::string>& words) const;

    [[nodiscard]] std::unordered_map<TypeRequest, std::size_t> GetWordCountByRequestType() const;

   private:
    userver::storages::postgres::ClusterPtr pg_;
};

}  // namespace voice_assistant::db::voice_statistics
