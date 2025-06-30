#include "session_encoding.h"

#include <oxenc/bt_serialize.h>

void encode_onion_proxy_request(
    const struct onion_proxy_request *request,
    void (*callback)(void *user_data, const unsigned char *encoded_request, size_t encoded_request_len),
    void *user_data)
{
    std::array<std::string_view, 2> payload = {
        {std::string_view{reinterpret_cast<const char *>(request->header), request->header_len},
         std::string_view{reinterpret_cast<const char *>(request->body), request->body_len}}};

    auto encoded_payload = oxenc::bt_serialize(payload);
    callback(user_data, reinterpret_cast<const unsigned char *>(encoded_payload.data()), encoded_payload.size());
}

bool decode_onion_proxy_response(
    const unsigned char *input,
    size_t input_len,
    struct onion_proxy_response *request)
{
    std::string_view result{reinterpret_cast<const char *>(input), input_len};
    try
    {
        oxenc::bt_list_consumer result_bencode{result};

        if (result_bencode.is_finished() || !result_bencode.is_string())
            return false;

        auto response_info = result_bencode.consume_string_view();
        auto body = result_bencode.consume_string_view();

        request->body = reinterpret_cast<const unsigned char *>(body.data());
        request->body_len = body.size();

        request->response_info = reinterpret_cast<const unsigned char *>(response_info.data());
        request->response_info_len = response_info.size();
    }
    catch (...) // catch all exceptions
    {
        return false;
    }

    return true;
}