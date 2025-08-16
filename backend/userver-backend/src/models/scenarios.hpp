#pragma once

namespace voice_assistant {

enum class TypeRequest {
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
  OTHER
};

}  // namespace voice_assistant
