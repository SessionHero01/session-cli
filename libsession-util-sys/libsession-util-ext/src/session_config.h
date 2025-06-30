#pragma once

#include <session/config/base.h>
#include <session/config/user_groups.h>

#ifdef __cplusplus
extern "C"
{
#endif
  /**
   * @return 1 if the config was merged, 0 if the config was not merged, -1 if an error occurred
   */
  LIBSESSION_EXPORT int session_config_merge(config_object *config,
                                             const unsigned char *data, size_t data_len,
                                             const char *hash, size_t hash_len,
                                             char *error_buf, size_t error_buf_len);

  /**
   * @return true if the blind15 ids were successfully generated
   * @param id1_out Hex-encoded 66 byte buffer for the first id
   * @param id2_out Hex-encoded 66 byte buffer for the second id
   * @param session_id The session id in hex with prefix
   * @param server_pk The server public key in hex
   */
  LIBSESSION_EXPORT bool session_blind15_ids(
      const char *session_id, size_t session_id_len,
      const char *server_pk, size_t server_pk_len,
      char *id1_out,
      char *id2_out);

  /**
   * @return true if the blind25 id was successfully generated
   * @param id_out Hex-encoded 66 byte buffer for the id
   * @param session_id The session id in hex with prefix
   * @param server_pk The server public key in hex
   */
  LIBSESSION_EXPORT bool session_blind25_id(
      const char *session_id, size_t session_id_len,
      const char *server_pk, size_t server_pk_len,
      char *id_out);

  LIBSESSION_EXPORT bool user_groups_create_group(const config_object *conf, ugroups_group_info *group);

#ifdef __cplusplus
}
#endif
