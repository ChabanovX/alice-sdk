#include "utils/send-request.hpp"

#include <userver/clients/http/client.hpp>
#include <userver/clients/http/component.hpp>

#include <cstdlib>
#include <stdexcept>

std::string SendHttpRequest(const userver::components::ComponentContext& component_context,
                            const char* url,
                            const std::string& body) {
    // Получаем HTTP-клиент из контекста компонента
    userver::clients::http::Client& httpClient =
        component_context.FindComponent<userver::components::HttpClient>().GetHttpClient();

    // Создаем и выполняем POST-запрос
    auto response = httpClient.CreateRequest().post(url).data(body).perform();

    // Проверяем результат
    if (!response->IsOk()) {
        throw std::runtime_error("HTTP request failed: " + std::to_string(response->status_code()));
    }

    return std::move(*response).body();
}

const char* getenvWithError(const char* key) noexcept(false) {
    const char* value = std::getenv(key);
    if (value == nullptr)
        throw std::runtime_error(std::string(std::string("Environmental variable ") + key + " is not set."));
    return value;
}
