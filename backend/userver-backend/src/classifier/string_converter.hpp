#pragma once

#include <codecvt>
#include <locale>
#include <string>

std::u32string utf8ToUtf32(const std::string& input) {
  std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
  return converter.from_bytes(input);
}

std::string utf32ToUtf8(const std::u32string& input) {
  std::wstring_convert<std::codecvt_utf8<char32_t>, char32_t> converter;
  return converter.to_bytes(input.data(), input.data() + input.size());
}
