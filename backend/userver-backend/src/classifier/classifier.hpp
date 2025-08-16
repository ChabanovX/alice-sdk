#pragma once

#include <filesystem>
#include <map>
#include <optional>
#include <set>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "../models/scenarios.hpp"

using namespace voice_assistant;

struct InfoClassifier {
  std::unordered_set<std::u32string> stop_words;
  std::unordered_set<std::u32string> all_words;
  std::unordered_map<TypeRequest, std::size_t> count_all_word_in_type;
  std::unordered_map<TypeRequest, std::unordered_map<std::u32string_view, uint>>
      freq_word_in_type;
  std::unordered_map<std::u32string_view, uint> freq_word_among_type;
};

void ChangeStatistics(const TypeRequest type,
                      std::vector<std::u32string>&& words);

class Classifier {
 public:
  Classifier() = delete;
  Classifier(InfoClassifier&& save_info, const float sensitivity = 15.7,
             const float power_unknown = 3100);
  Classifier(Classifier&& other);

  std::optional<TypeRequest> GetTypeRequest(
      const std::u32string& text_request) const;

  void ChangeStatisticLastRequest(const TypeRequest type) const;

  bool CleanCache() const;

 private:
  const std::size_t COUNT_TYPE_REQUEST =
      static_cast<std::size_t>(TypeRequest::OTHER);

  float sensitivity_;
  float power_unknown_;

  const std::unordered_set<std::u32string> stop_words_;

  const std::unordered_set<std::u32string> all_words_;
  const std::unordered_map<TypeRequest, std::size_t> count_all_word_in_type_;
  const std::unordered_map<TypeRequest,
                           std::unordered_map<std::u32string_view, uint>>
      freq_word_in_type_;
  const std::unordered_map<std::u32string_view, uint> freq_word_among_type_;

  mutable std::vector<std::u32string> cache_last_request_;

  std::pair<std::multimap<float, TypeRequest>, float> GetRankedList(
      std::u32string text_request) const;
};