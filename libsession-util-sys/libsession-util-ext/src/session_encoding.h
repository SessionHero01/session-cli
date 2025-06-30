#pragma once

#include <stdlib.h>
#include <stdint.h>

#include <session/export.h>

#ifdef __cplusplus
extern "C"
{
#endif

    struct onion_proxy_request
    {
        const unsigned char *header;
        size_t header_len;

        const unsigned char *body;
        size_t body_len;
    };

    struct onion_proxy_response
    {
        const unsigned char *response_info;
        size_t response_info_len;

        const unsigned char *body;
        size_t body_len;
    };

    LIBSESSION_EXPORT
    void encode_onion_proxy_request(
        const struct onion_proxy_request *request,
        void (*callback)(void *user_data, const unsigned char *encoded_request, size_t encoded_request_len),
        void *user_data);

    LIBSESSION_EXPORT
    bool decode_onion_proxy_response(
        const unsigned char *input,
        size_t input_len,
        struct onion_proxy_response *request);

#ifdef __cplusplus
}
#endif
