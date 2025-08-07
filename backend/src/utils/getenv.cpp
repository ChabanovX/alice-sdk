#include <cstdlib>
#include <stdexcept>
#include <string>

namespace voice_assistant::utils {

const char* getenvWithError(const char* key) noexcept(false) {
    const char* value = std::getenv(key);
    if (!value) throw std::runtime_error(std::string("Environmental variable ") + key + " is not set.");
    return value;
}

}  // namespace voice_assistant::utils
