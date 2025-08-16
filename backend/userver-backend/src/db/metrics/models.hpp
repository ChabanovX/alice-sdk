#pragma once

namespace voice_assistant::db::metrics {

enum class CounterCategory : char {
    kCancellations,
    kRepetitions,
    kFallbacks,
};

enum class TimingCategory : char {
    kCreateRoute,
    kBusiness,
    kOrderDeciding,
};

}  // namespace voice_assistant::db::metrics
