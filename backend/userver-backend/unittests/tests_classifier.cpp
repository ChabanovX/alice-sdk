#include <userver/utest/utest.hpp>
#include "../src/classifier/classifier_fabric.hpp"
#include "../src/classifier/classifier.hpp"
#include "../src/models/scenarios.hpp"
#include <string>
#include <optional>
#include <locale>

using namespace voice_assistant;

class SerializeFixture : public ::testing::Test {
protected:
    SerializeFixture() : cl(CreateClassifierFromSave()){}
    void SetUp() override {}
    void TearDown() override {}
    Classifier cl;
};
TEST_F(SerializeFixture, all_types_request){
    std::u32string request = U"Забираю заказ";
    std::optional<TypeRequest> result = TypeRequest::ACCEPT_ORDER;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break ACCEPT_ORDER";
    request = U"Не могу принять сейчас";
    result = TypeRequest::CANCEL_ORDER;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break CANCEL_ORDER";
    request = U"Что там в чате?";
    result = TypeRequest::VOICE_MESSAGE;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break VOICE_MESSAGE";
    request = U"Есть ли специальные требования?";
    result = TypeRequest::VOICE_WISH;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break VOICE_WISH";
    request = U"Перезвони пассажиру";
    result = TypeRequest::CALL_PASSENGER;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break ::CALL_PASSENGER";
    request = U"Как доехать до ул. планетная, пять";
    result = TypeRequest::CREATE_ROUTE;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break CREATE_ROUTE";
    request = U"Подойдет второй";
    result = TypeRequest::CHOOSE_ROUTE;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break CHOOSE_ROUTE";
    request = U"Мне нужно по делам в МФЦ";
    result = TypeRequest::BUSINESS;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break BUSINESS";
    request = U"Уже поздно, пора домой";
    result = TypeRequest::HOME;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break HOME";
    request = U"Найди мне ближайший туалет";
    result = TypeRequest::FIND;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break FIND";
    request = U"Смени тариф на комфорт";
    result = TypeRequest::CHANGE_FARE;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break CHANGE_FARE";
    request = U"Это не те дроиды, которых вы ищете";
    result = TypeRequest::OTHER ;
    EXPECT_TRUE((cl.GetTypeRequest(request) == result) || (cl.GetTypeRequest(request) == std::nullopt)) << "Break OTHER";
}