#include "repository.hpp"

#include "models.hpp"
#include "models/scenarios.hpp"

#include <userver/storages/postgres/cluster.hpp>
#include <userver/storages/postgres/cluster_types.hpp>
#include <userver/storages/postgres/io/io_fwd.hpp>
#include <userver/storages/postgres/io/row_types.hpp>
#include <userver/utils/trivial_map.hpp>

#include <cstddef>
#include <cstdint>
#include <string>
#include <tuple>
#include <unordered_map>
#include <utility>
#include <vector>

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

struct CountInRequestType {
    RequestType type;
    std::int64_t count;
};

struct WordStatistics {
    std::string word;
    std::vector<CountInRequestType> count_by_request_type;
};

}  // namespace db_internal

}  // namespace

template <>
struct userver::storages::postgres::io::CppToUserPg<db_internal::RequestType> {
    static constexpr DBTypeName postgres_name = "voice_statistics.request_type";     // NOLINT(*unused*)
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
struct userver::storages::postgres::io::CppToUserPg<db_internal::CountInRequestType> {
    static constexpr DBTypeName postgres_name = "voice_statistics.count_in_request_type";  // NOLINT(*unused*)
};

template <>
struct userver::storages::postgres::io::CppToUserPg<db_internal::WordStatistics> {
    static constexpr DBTypeName postgres_name = "voice_statistics.word_statistics";  // NOLINT(*unused*)
};

namespace voice_assistant::db::voice_statistics {

Repository::Repository(userver::storages::postgres::ClusterPtr db_cluster) : pg_{std::move(db_cluster)} {}

std::vector<std::string> Repository::GetStopWords() const {
    return pg_
        ->Execute(userver::storages::postgres::ClusterHostType::kSlave,
                  "SELECT word "
                  "FROM voice_statistics.stop_words ")
        .AsContainer<std::vector<std::string>>();
}

void Repository::UpdateStatistics(TypeRequest request_type, const std::vector<std::string>& words) const {
    if (request_type == TypeRequest::OTHER) return;
    pg_->Execute(userver::storages::postgres::ClusterHostType::kMaster,
                 "CALL voice_statistics.update_statistics($1, $2)",
                 words,
                 static_cast<db_internal::RequestType>(request_type));
}

std::unordered_map<std::string, WordStatistics> Repository::GetStatistics(const std::vector<std::string>& words) const {
    auto rows = pg_->Execute(userver::storages::postgres::ClusterHostType::kSlave,
                             "SELECT voice_statistics.get_words_statistics($1)",
                             words)
                    .AsSetOf<db_internal::WordStatistics>();
    std::unordered_map<std::string, WordStatistics> result;
    for (auto row : rows) {
        WordStatistics domain_object;
        domain_object.used_in_types_count = row.count_by_request_type.size();
        for (auto& count_rec : row.count_by_request_type) {
            domain_object.count_by_request_type.emplace(static_cast<TypeRequest>(count_rec.type), count_rec.count);
        }
        result.emplace(row.word, std::move(domain_object));
    }
    return result;
}

std::unordered_map<TypeRequest, std::size_t> Repository::GetWordCountByRequestType() const {
    auto rows = pg_->Execute(userver::storages::postgres::ClusterHostType::kSlave,
                             "SELECT type, count "
                             "FROM voice_statistics.words_count_by_type ")
                    .AsSetOf<std::tuple<db_internal::RequestType, long>>(userver::storages::postgres::kRowTag);
    std::unordered_map<TypeRequest, std::size_t> result;
    for (auto row : rows) {
        result.emplace(static_cast<TypeRequest>(std::get<0>(row)), std::get<1>(row));
    }
    return result;
}

}  // namespace voice_assistant::db::voice_statistics
