#include "classifier.hpp"

#include <cctype>
#include <cmath>
#include <cstddef>
#include <iterator>
#include <map>
#include <optional>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>

#include "../models/scenarios.hpp"

namespace voice_assistant {

namespace {

constexpr std::size_t kRequestTypesCount = static_cast<std::size_t>(TypeRequest::OTHER);

}  // namespace

Classifier::Classifier(InfoClassifier&& save_info, const float sensitivity, const float power_unknown)
    : sensitivity_(sensitivity), power_unknown_(power_unknown), info_{std::move(save_info)} {}

std::optional<TypeRequest> Classifier::GetTypeRequest(const std::u32string& text_request) const {
    const auto& [ranked_list, unknown_part] = GetRankedList(text_request);

    const auto it_back = std::prev(ranked_list.end());
    const auto [max_ref, max_type] = *it_back;
    const auto it_prev_back = std::prev(it_back);
    const auto [prev_max_ref, prev_max_type] = *it_prev_back;
    if (info_.count_all_word_in_type.count(max_type) && (info_.count_all_word_in_type.at(max_type) != 0) &&
        (max_ref - unknown_part * power_unknown_ / info_.count_all_word_in_type.at(max_type) < 0)) {
        return TypeRequest::OTHER;
    }
    if (prev_max_ref * sensitivity_ < max_ref) {
        return max_type;
    }
    return std::nullopt;
}

std::pair<std::multimap<float, TypeRequest>, float> Classifier::GetRankedList(std::u32string text_request) const {
    std::unordered_map<TypeRequest, float> res;
    for (std::size_t i = 0; i < kRequestTypesCount; ++i) {
        res.insert({static_cast<TypeRequest>(i), 0});
    }
    bool word_is_started = false;
    std::u32string word;
    std::u32string clean_text;
    text_request.push_back(U'.');
    std::size_t count_unknown_word = 0;
    std::size_t count_word = 0;
    for (char32_t ch : text_request) {
        if ((ch >= U'А' && ch <= U'я') || ch == U'Ё' || ch == U'ё' || std::isalnum(ch) != 0) {
            ch += ((ch >= U'А' && ch <= U'Я')) ? (U'а' - U'А') : 0;
            ch = (((ch == U'ё') || (ch == U'Ё')) ? U'e' : ch);
            word.push_back(ch);
            word_is_started = true;
        } else {
            if (word_is_started) {
                ++count_word;
                if (info_.stop_words.count(word) == 0) {
                    if (info_.all_words.count(word) != 0) {
                        for (const auto& [type, freq_word] : info_.freq_word_in_type) {
                            if (freq_word.count(word) != 0U) {
                                res[type] = freq_word.at(word) /
                                            static_cast<float>(info_.count_all_word_in_type.at(type)) *
                                            std::log(kRequestTypesCount /
                                                     static_cast<float>(info_.freq_word_among_type.at(word)));
                            }
                        }
                    } else {
                        ++count_unknown_word;
                    }
                    clean_text += word + U' ';
                }
                word_is_started = false;
                word.clear();
            }
        }
    }
    text_request = std::move(clean_text);
    std::multimap<float, TypeRequest> ans;
    for (auto [type, tf_idf] : res) {
        ans.insert({tf_idf, type});
    }
    return {std::move(ans), count_unknown_word / static_cast<float>(count_word)};
}

}  // namespace voice_assistant
