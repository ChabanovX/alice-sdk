#include "bridge-ai-python.hpp"

#include "utils/getenv.hpp"
#include "utils/send-request.hpp"

std::string ClassifyMessageWithAI(const userver::components::ComponentContext& component_context,
                                  const std::string& raw_text) {
    const std::string env_name_api = "CLASSIFIER_AI_API_URL";
    const char* url = getenvWithError(env_name_api.data());

    std::string res_json = SendHttpRequest(component_context, url, raw_text);
    return res_json;
}
