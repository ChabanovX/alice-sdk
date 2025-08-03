#include "view.hpp"

#include <userver/components/component_context.hpp>
#include <userver/formats/json.hpp>
#include <userver/server/handlers/http_handler_base.hpp>
#include <userver/utils/assert.hpp>

namespace classifier {

namespace {

class GetRawMessage final : public userver::server::handlers::HttpHandlerBase {
public:
    static constexpr std::string_view kName = "handler-v1-get-raw-message";

    using HttpHandlerBase::HttpHandlerBase;

    std::string HandleRequestThrow(
        const userver::server::http::HttpRequest& request,
        userver::server::request::RequestContext&
    ) const override {
        const auto body = request.RequestBody();

        const auto json = userver::formats::json::FromString(body);
        const std::string text = json["text"].As<std::string>();

        return text;
    }
};

}  // namespace

void AppendGetRawMessage(userver::components::ComponentList& component_list) {
    component_list.Append<GetRawMessage>();
}

}  // namespace classifier
