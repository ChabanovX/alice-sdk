#include <cstdlib>
#include <stdexcept>
#include <string>

const char* getenvWithError(const char* key) noexcept(false) {
    const char* value = std::getenv(key);
    if (!value) throw std::runtime_error(std::string("Environmental variable ") + key + " is not set.");
    return value;
}
