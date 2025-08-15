#include "repository.hpp"

#include "db/voice_statistics/models.hpp"
#include "models/scenarios.hpp"

#include <cstdint>
#include <userver/storages/postgres/cluster.hpp>
#include <userver/storages/postgres/cluster_types.hpp>
#include <userver/storages/postgres/io/io_fwd.hpp>
#include <userver/storages/postgres/io/row_types.hpp>
#include <userver/utils/trivial_map.hpp>

#include <cstddef>
#include <string>
#include <tuple>
#include <unordered_map>
#include <utility>
#include <vector>

template <>
struct userver::storages::postgres::io::CppToUserPg<voice_assistant::TypeRequest> {
    static constexpr DBTypeName postgres_name = "voice_statistics.request_type";
    static constexpr userver::utils::TrivialBiMap enumerators = [](auto selector) {
        return selector()
            .Case("accept", voice_assistant::TypeRequest::ACCEPT_ORDER)
            .Case("cancel", voice_assistant::TypeRequest::CANCEL_ORDER)
            .Case("voice_message", voice_assistant::TypeRequest::VOICE_MESSAGE)
            .Case("voice_wish", voice_assistant::TypeRequest::VOICE_WISH)
            .Case("call_passenger", voice_assistant::TypeRequest::CALL_PASSENGER)
            .Case("create_route", voice_assistant::TypeRequest::CREATE_ROUTE)
            .Case("choose_route", voice_assistant::TypeRequest::CHOOSE_ROUTE)
            .Case("business", voice_assistant::TypeRequest::BUSINESS)
            .Case("home", voice_assistant::TypeRequest::HOME)
            .Case("find", voice_assistant::TypeRequest::FIND)
            .Case("change_rate", voice_assistant::TypeRequest::СHANGE_FARE);
    };
};

namespace db_internal {

struct CountInRequestType {
    voice_assistant::TypeRequest type;
    std::int64_t count;
};

struct WordStatistics {
    std::string word;
    std::vector<CountInRequestType> count_by_request_type;
};

}  // namespace db_internal

template <>
struct userver::storages::postgres::io::CppToUserPg<db_internal::CountInRequestType> {
    static constexpr DBTypeName postgres_name = "voice_statistics.count_in_request_type";
};

template <>
struct userver::storages::postgres::io::CppToUserPg<db_internal::WordStatistics> {
    static constexpr DBTypeName postgres_name = "voice_statistics.word_statistics";
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
    pg_->Execute(userver::storages::postgres::ClusterHostType::kMaster,
                 "CALL voice_statistics.update_statistics($1, $2)",
                 words,
                 request_type);
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
            domain_object.count_by_request_type.emplace(count_rec.type, count_rec.count);
        }
        result.emplace(row.word, std::move(domain_object));
    }
    return result;
}

std::unordered_map<TypeRequest, std::size_t> Repository::GetWordCountByRequestType() const {
    auto rows = pg_->Execute(userver::storages::postgres::ClusterHostType::kSlave,
                             "SELECT type, count "
                             "FROM voice_statistics.words_count_by_type ")
                    .AsSetOf<std::tuple<TypeRequest, long>>(userver::storages::postgres::kRowTag);
    std::unordered_map<TypeRequest, std::size_t> result;
    for (auto row : rows) {
        result.emplace(std::get<0>(row), std::get<1>(row));
    }
    return result;
}

}  // namespace voice_assistant::db::voice_statistics
