#include "view.hpp"

#include <userver/components/component_context.hpp>
#include <userver/formats/json.hpp>
#include <userver/server/handlers/http_handler_base.hpp>
#include <userver/utils/assert.hpp>

namespace classifier {

namespace {

class СlassifyMessage final : public userver::server::handlers::HttpHandlerBase {
   public:
    static constexpr std::string_view kName = "handler-v1-classify-message";

    using HttpHandlerBase::HttpHandlerBase;

    std::string HandleRequestThrow(const userver::server::http::HttpRequest& request,
                                   userver::server::request::RequestContext&) const override {
        const auto body = request.RequestBody();

        if (request.RequestBody().empty()) {
            auto& response = request.GetHttpResponse();
            response.SetStatus(userver::server::http::HttpStatus::kBadRequest);
            return "Request body is empty!";
        }

        const auto json = userver::formats::json::FromString(body);

        if (!json.HasMember("text")) {
            auto& response = request.GetHttpResponse();
            response.SetStatus(userver::server::http::HttpStatus::kBadRequest);
            return "No member text in json!";
        }

        const std::string text = json["text"].As<std::string>();

        return text;
    }
};

}  // namespace

void AppendСlassifyMessage(userver::components::ComponentList& component_list) {
    component_list.Append<СlassifyMessage>();
}

}  // namespace classifier
