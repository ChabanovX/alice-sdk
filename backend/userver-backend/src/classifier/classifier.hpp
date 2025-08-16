#pragma once

#include <map>
#include <optional>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>

#include "../models/scenarios.hpp"

namespace voice_assistant {

struct InfoClassifier {
    std::unordered_set<std::u32string> stop_words;
    std::unordered_set<std::u32string> all_words;
    std::unordered_map<TypeRequest, std::size_t> count_all_word_in_type;
    std::unordered_map<TypeRequest, std::unordered_map<std::u32string_view, uint>> freq_word_in_type;
    std::unordered_map<std::u32string_view, uint> freq_word_among_type;
};

class Classifier {
   public:
    explicit Classifier(InfoClassifier&& save_info,
                        float sensitivity = 15.7,     // NOLINT(*magic-number*)
                        float power_unknown = 3100);  // NOLINT(*magic-number*)

    std::optional<TypeRequest> GetTypeRequest(const std::u32string& text_request) const;

   private:
    float sensitivity_;
    float power_unknown_;

    InfoClassifier info_;

    std::pair<std::multimap<float, TypeRequest>, float> GetRankedList(std::u32string text_request) const;
};

}  // namespace voice_assistant
