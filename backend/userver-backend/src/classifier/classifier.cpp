#include "classifier.hpp"

#include <cctype>
#include <cmath>
#include <filesystem>
#include <iterator>
#include <map>
#include <optional>
#include <set>
#include <sstream>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

#include "../models/scenarios.hpp"


using namespace voice_assistant;

Classifier::Classifier(InfoClassifier&& save_info, const float sensitivity,
                       const float power_unknown)
    : sensitivity_(sensitivity),
      power_unknown_(power_unknown),
      stop_words_(std::move(save_info.stop_words)),
      all_words_(std::move(save_info.all_words)),
      count_all_word_in_type_(std::move(save_info.count_all_word_in_type)),
      freq_word_in_type_(std::move(save_info.freq_word_in_type)),
      freq_word_among_type_(std::move(save_info.freq_word_among_type)) {}

Classifier::Classifier(Classifier&& other)
    : sensitivity_(other.sensitivity_),
      power_unknown_(other.power_unknown_),
      stop_words_(std::move(other.stop_words_)),
      all_words_(std::move(other.all_words_)),
      count_all_word_in_type_(std::move(other.count_all_word_in_type_)),
      freq_word_in_type_(std::move(other.freq_word_in_type_)),
      freq_word_among_type_(std::move(other.freq_word_among_type_)) {}

void Classifier::ChangeStatisticLastRequest(const TypeRequest type) const {
  ChangeStatistics(type, std::move(cache_last_request_));
}

std::optional<TypeRequest> Classifier::GetTypeRequest(
    const std::u32string& text_request) const {
  const auto& [ranked_list, unknown_part] = GetRankedList(text_request);

  const auto it_back = std::prev(ranked_list.end());
  const auto [max_ref, max_type] = *it_back;
  const auto it_prev_back = std::prev(it_back);
  const auto [prev_max_ref, prev_max_type] = *it_prev_back;
  if (count_all_word_in_type_.count(max_type) &&
      (count_all_word_in_type_.at(max_type) != 0) &&
      (max_ref - unknown_part * power_unknown_ /
                     count_all_word_in_type_.at(max_type) <
       0)) {
    return TypeRequest::OTHER;
  }
  if (prev_max_ref * sensitivity_ < max_ref) {
    return max_type;
  }
  return std::nullopt;
}

std::pair<std::multimap<float, TypeRequest>, float> Classifier::GetRankedList(
    std::u32string text_request) const {
  std::unordered_map<TypeRequest, float> res;
  for (int i = 0; i < COUNT_TYPE_REQUEST; ++i) {
    res.insert({static_cast<TypeRequest>(i), 0});
  }
  bool word_is_started = false;
  std::u32string word;
  std::u32string clean_text;
  text_request.push_back(U'.');
  std::size_t count_unknown_word = 0, count_word = 0;
  for (char32_t ch : text_request) {
    if ((ch >= U'А' && ch <= U'я') || ch == U'Ё' || ch == U'ё' ||
        (std::isalnum(ch))) {
      ch += ((ch >= U'А' && ch <= U'Я')) ? (U'а' - U'А') : 0;
      ch = (((ch == U'ё') || (ch == U'Ё')) ? U'e' : ch);
      word.push_back(ch);
      word_is_started = true;
    } else {
      if (word_is_started) {
        ++count_word;
        if (!stop_words_.count(word)) {
          if (all_words_.count(word)) {
            for (const auto& [type, freq_word] : freq_word_in_type_) {
              if (freq_word.count(word)) {
                res[type] =
                    freq_word.at(word) /
                    static_cast<float>(count_all_word_in_type_.at(type)) *
                    std::log(
                        COUNT_TYPE_REQUEST /
                        static_cast<float>(freq_word_among_type_.at(word)));
              }
            }
          } else {
            ++count_unknown_word;
          }
          clean_text += word + U' ';
        }
        word_is_started = false;
        cache_last_request_.push_back(std::move(word));
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

bool Classifier::CleanCache() const {
  if (cache_last_request_.empty()) {
    return false;
  }
  cache_last_request_.clear();
  return true;
}
