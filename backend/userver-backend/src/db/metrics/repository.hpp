#pragma once

#include "models.hpp"
#include "models/scenarios.hpp"

#include <userver/storages/postgres/postgres_fwd.hpp>
#include <userver/utils/datetime.hpp>

#include <chrono>
#include <cstddef>
#include <optional>
#include <string_view>

namespace voice_assistant::db::metrics {

struct LastRequestInfo {  // NOLINT(*member-init)
    TypeRequest type;
    std::chrono::system_clock::time_point response_time;
};

struct RetentionStats {
    std::size_t total_requests = 0;
    std::chrono::system_clock::time_point first_request_time;
    std::optional<std::chrono::system_clock::time_point> third_request_time;
};

class Repository {
   public:
    explicit Repository(userver::storages::postgres::ClusterPtr db_cluster);

    void RegisterRequest(std::string_view session_id,
                         std::string_view user_id,
                         TypeRequest type,
                         std::chrono::system_clock::time_point now,
                         double request_duration_seconds) const;

    [[nodiscard]] std::optional<LastRequestInfo> GetLastRequest(std::string_view user_id) const;

    // Counter operations
    void IncrementCounter(CounterCategory category, std::size_t increment = 1) const;
    [[nodiscard]] std::size_t GetCounterValue(CounterCategory category) const;

    // Retention stats operations
    [[nodiscard]] std::optional<RetentionStats> GetRetentionStats(std::string_view user_id) const;

    // Timing operations
    [[nodiscard]] double GetAverageTime(TimingCategory category) const;

   private:
    userver::storages::postgres::ClusterPtr pg_cluster_;
};

}  // namespace voice_assistant::db::metrics
