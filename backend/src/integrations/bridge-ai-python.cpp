#include "bridge-ai-python.hpp"

#include "utils/getenv.hpp"
#include "utils/send-request.hpp"

namespace voice_assistant::bridges::ai_python {

std::string ClassifyMessageWithAI(const userver::components::ComponentContext& component_context,
                                  const std::string& raw_text) {
    const std::string env_name_api = "CLASSIFIER_AI_API_URL";
    const char* url = utils::getenvWithError(env_name_api.data());

    std::string res_json = utils::SendHttpRequest(component_context, url, raw_text);
    return res_json;
}

}  // namespace voice_assistant::bridges::ai_python
