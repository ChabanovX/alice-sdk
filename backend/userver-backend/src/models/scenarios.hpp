#pragma once

namespace voice_assistant {

enum class TypeRequest : char {
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
    СHANGE_FARE,
    COUNT_  // count elements in enum
};

}  // namespace voice_assistant
