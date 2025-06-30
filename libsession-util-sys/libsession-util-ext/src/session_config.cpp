#include "session_config.h"

#include <iostream>
#include <session/config/base.hpp>
#include <session/config/user_groups.hpp>
#include <session/blinding.hpp>

#include <string_view>
#include <span>

LIBSESSION_EXPORT int session_config_merge(
    config_object *config,
    const unsigned char *data, size_t data_len,
    const char *hash, size_t hash_len,
    char *error_buf, size_t error_buf_len)
{
    std::span<const unsigned char> data_view(data, data_len);
    std::string hash_str(hash, hash_len);

    auto &config_base = session::config::unbox<session::config::ConfigBase>(config);

    std::pair<std::string, std::span<const unsigned char>> hash_and_data(hash_str, data_view);

    try
    {
        return config_base.config->merge({hash_and_data}).size();
    }
    catch (const std::exception &ec)
    {
        if (error_buf)
        {
            strncpy(error_buf, ec.what(), error_buf_len);
        }
        return -1;
    }
}

LIBSESSION_EXPORT bool session_blind15_ids(
    const char *session_id, size_t session_id_len,
    const char *server_pk, size_t server_pk_len,
    char *id1_out,
    char *id2_out)
{
    std::string_view session_id_view(session_id, session_id_len);
    std::string_view server_pk_view(server_pk, server_pk_len);

    try
    {
        auto [id1, id2] = session::blind15_id(session_id_view, server_pk_view);
        memcpy(id1_out, id1.data(), id1.size());
        memcpy(id2_out, id2.data(), id2.size());

        return true;
    }
    catch (...)
    {
        return false;
    }
}

LIBSESSION_EXPORT bool session_blind25_id(
    const char *session_id, size_t session_id_len,
    const char *server_pk, size_t server_pk_len,
    char *id_out)
{
    std::string_view session_id_view(session_id, session_id_len);
    std::string_view server_pk_view(server_pk, server_pk_len);

    try
    {
        auto id = session::blind25_id(session_id_view, server_pk_view);
        memcpy(id_out, id.data(), id.size());

        return true;
    }
    catch (...)
    {
        return false;
    }
}

LIBSESSION_EXPORT bool user_groups_create_group(const config_object *conf, ugroups_group_info *group)
{
    session::config::unbox<session::config::UserGroups>(conf)->create_group().into(*group);
    return true;
}
