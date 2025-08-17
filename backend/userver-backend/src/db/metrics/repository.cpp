#include "repository.hpp"

#include "models.hpp"
#include "models/scenarios.hpp"

#include <userver/storages/postgres/cluster.hpp>
#include <userver/storages/postgres/cluster_types.hpp>
#include <userver/storages/postgres/component.hpp>
#include <userver/storages/postgres/io/chrono.hpp>
#include <userver/utils/datetime.hpp>
#include <userver/utils/trivial_map.hpp>

#include <cstddef>
#include <cstdint>
#include <optional>

namespace {

namespace db_internal {

enum class RequestType : char {
    ACCEPT_ORDER,
    CANCEL_ORDER,
    VOICE_MESSAGE,
    VOICE_WISH,
    CALL_PASSENGER,
    CREATE_ROUTE,
    CHOOSE_ROUTE,
    BUSINESS,
    HOME,
    FIND,
    CHANGE_FARE,
};

}  // namespace db_internal

}  // namespace

template <>
struct userver::storages::postgres::io::CppToUserPg<db_internal::RequestType> {
    static constexpr DBTypeName postgres_name = "metrics.request_type";              // NOLINT(*unused*)
    static constexpr userver::utils::TrivialBiMap enumerators = [](auto selector) {  // NOLINT(*unused*)
        return selector()
            .Case("accept", db_internal::RequestType::ACCEPT_ORDER)
            .Case("cancel", db_internal::RequestType::CANCEL_ORDER)
            .Case("voice_message", db_internal::RequestType::VOICE_MESSAGE)
            .Case("voice_wish", db_internal::RequestType::VOICE_WISH)
            .Case("call_passenger", db_internal::RequestType::CALL_PASSENGER)
            .Case("create_route", db_internal::RequestType::CREATE_ROUTE)
            .Case("choose_route", db_internal::RequestType::CHOOSE_ROUTE)
            .Case("business", db_internal::RequestType::BUSINESS)
            .Case("home", db_internal::RequestType::HOME)
            .Case("find", db_internal::RequestType::FIND)
            .Case("change_rate", db_internal::RequestType::CHANGE_FARE);
    };
};

template <>
struct userver::storages::postgres::io::CppToUserPg<voice_assistant::db::metrics::CounterCategory> {
    static constexpr DBTypeName postgres_name = "metrics.counter_category";
    static constexpr userver::utils::TrivialBiMap enumerators = [](auto selector) {
        return selector()
            .Case("cancellation", voice_assistant::db::metrics::CounterCategory::kCancellations)
            .Case("repetitions", voice_assistant::db::metrics::CounterCategory::kRepetitions)
            .Case("fallbacks", voice_assistant::db::metrics::CounterCategory::kFallbacks);
    };
};

template <>
struct userver::storages::postgres::io::CppToUserPg<voice_assistant::db::metrics::TimingCategory> {
    static constexpr DBTypeName postgres_name = "metrics.timing_category";
    static constexpr userver::utils::TrivialBiMap enumerators = [](auto selector) {
        return selector()
            .Case("create_route", voice_assistant::db::metrics::TimingCategory::kCreateRoute)
            .Case("business", voice_assistant::db::metrics::TimingCategory::kBusiness)
            .Case("order_deciding", voice_assistant::db::metrics::TimingCategory::kOrderDeciding);
    };
};

namespace voice_assistant::db::metrics {

Repository::Repository(userver::storages::postgres::ClusterPtr db_cluster) : pg_cluster_(std::move(db_cluster)) {}

void Repository::RegisterRequest(std::string_view session_id,
                                 std::string_view user_id,
                                 TypeRequest type,
                                 std::chrono::system_clock::time_point now,
                                 double request_duration_seconds) const {
    if (type == TypeRequest::OTHER) return;
    pg_cluster_->Execute(userver::storages::postgres::ClusterHostType::kMaster,
                         "CALL metrics.register_request($1, $2, $3, $4, $5) ",
                         session_id,
                         user_id,
                         static_cast<db_internal::RequestType>(type),
                         userver::storages::postgres::TimePointTz{now},
                         request_duration_seconds);
}

std::optional<LastRequestInfo> Repository::GetLastRequest(std::string_view user_id) const {
    auto result = pg_cluster_->Execute(userver::storages::postgres::ClusterHostType::kSlave,
                                       "SELECT type, request_ts "
                                       "FROM metrics.last_requests "
                                       "WHERE user_id = $1 ",
                                       user_id);

    if (result.IsEmpty()) {
        return std::nullopt;
    }

    auto row = result.Front();
    return LastRequestInfo{static_cast<TypeRequest>(row["type"].As<db_internal::RequestType>()),
                           row["request_ts"].As<userver::storages::postgres::TimePointTz>()};
}

void Repository::IncrementCounter(CounterCategory category, std::size_t increment) const {
    pg_cluster_->Execute(userver::storages::postgres::ClusterHostType::kMaster,
                         "UPDATE metrics.counters "
                         "SET value = value + $2 "
                         "WHERE name = $1 ",
                         category,
                         static_cast<std::int64_t>(increment));
}

std::size_t Repository::GetCounterValue(CounterCategory category) const {
    auto result = pg_cluster_->Execute(userver::storages::postgres::ClusterHostType::kSlave,
                                       "SELECT value "
                                       "FROM metrics.counters "
                                       "WHERE name = $1 ",
                                       category);
    return result.AsSingleRow<std::optional<std::int64_t>>().value_or(0);
}

std::optional<RetentionStats> Repository::GetRetentionStats(std::string_view user_id) const {
    auto result = pg_cluster_->Execute(userver::storages::postgres::ClusterHostType::kSlave,
                                       "SELECT total_requests, first_request_ts, third_request_ts "
                                       "FROM metrics.retention_stats "
                                       "WHERE user_id = $1 ",
                                       user_id);

    if (result.IsEmpty()) {
        return std::nullopt;
    }

    auto row = result.Front();
    auto third_time = row["third_request_ts"].As<std::optional<userver::storages::postgres::TimePointTz>>();
    return RetentionStats{static_cast<std::size_t>(row["total_requests"].As<std::int64_t>()),
                          row["first_request_ts"].As<userver::storages::postgres::TimePointTz>(),
                          third_time.has_value() ? std::optional{third_time->GetUnderlying()} : std::nullopt};
}

double Repository::GetAverageTime(TimingCategory category) const {
    auto result = pg_cluster_->Execute(userver::storages::postgres::ClusterHostType::kSlave,
                                       "SELECT sum_s / count "
                                       "FROM metrics.timings "
                                       "WHERE category = $1 ",
                                       category);
    return result.AsSingleRow<double>();
}

}  // namespace voice_assistant::db::metrics
