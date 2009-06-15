/* This file is auto generated from Drizzle.xs.tt. Do not modify directly */
/*
    vim: ft=xs
*/
#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include <libdrizzle/drizzle_client.h>
#include <libdrizzle/drizzle_server.h>
#ifdef __cplusplus
}
#endif

typedef struct net_con {
    SV * drizzle;
    drizzle_con_st * con;
} net_con;

typedef struct net_sth {
    SV * drizzle;
    SV * con;
    drizzle_query_st *query;
    drizzle_result_st *result;
} net_sth;

typedef struct net_col {
    SV * drizzle;
    SV * con;
    SV * result;
    drizzle_column_st *col;
} net_col;

#if 1
#define LOG(...) PerlIO_printf(PerlIO_stderr(), __VA_ARGS__)
#else
#define LOG(...)
#endif

#define DEF_RESULT(c) drizzle_result_st *result = (c)->result ? (c)->result : drizzle_query_result((c)->query)

#define XS_STATE(type, x) \
    (INT2PTR(type, SvROK(x) ? SvIV(SvRV(x)) : SvIV(x)))

#define XS_STRUCT2OBJ(sv, class, obj) \
    if (obj == NULL) { \
        sv_setsv(sv, &PL_sv_undef); \
    } else { \
        sv_setref_pv(sv, class, (void *) obj); \
    }


MODULE = Net::Drizzle  PACKAGE = Net::Drizzle

PROTOTYPES: DISABLE

BOOT:
    HV* stash = gv_stashpvn("Net::Drizzle", strlen("Net::Drizzle"), TRUE);
    newCONSTSUB(stash, "DRIZZLE_DEFAULT_TCP_HOST", newSVpv(DRIZZLE_DEFAULT_TCP_HOST, strlen(DRIZZLE_DEFAULT_TCP_HOST)));
    newCONSTSUB(stash, "DRIZZLE_DEFAULT_TCP_PORT", newSViv(DRIZZLE_DEFAULT_TCP_PORT));
    newCONSTSUB(stash, "DRIZZLE_DEFAULT_TCP_PORT_MYSQL", newSViv(DRIZZLE_DEFAULT_TCP_PORT_MYSQL));
    newCONSTSUB(stash, "DRIZZLE_DEFAULT_UDS", newSVpv(DRIZZLE_DEFAULT_UDS, strlen(DRIZZLE_DEFAULT_UDS))); 
    newCONSTSUB(stash, "DRIZZLE_DEFAULT_USER", newSVpv(DRIZZLE_DEFAULT_USER, strlen(DRIZZLE_DEFAULT_USER)));
    newCONSTSUB(stash, "DRIZZLE_MAX_ERROR_SIZE", newSViv(DRIZZLE_MAX_ERROR_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_USER_SIZE", newSViv(DRIZZLE_MAX_USER_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_PASSWORD_SIZE", newSViv(DRIZZLE_MAX_PASSWORD_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_DB_SIZE", newSViv(DRIZZLE_MAX_DB_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_INFO_SIZE", newSViv(DRIZZLE_MAX_INFO_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_SQLSTATE_SIZE", newSViv(DRIZZLE_MAX_SQLSTATE_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_CATALOG_SIZE", newSViv(DRIZZLE_MAX_CATALOG_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_TABLE_SIZE", newSViv(DRIZZLE_MAX_TABLE_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_COLUMN_NAME_SIZE", newSViv(DRIZZLE_MAX_COLUMN_NAME_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_DEFAULT_VALUE_SIZE", newSViv(DRIZZLE_MAX_DEFAULT_VALUE_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_PACKET_SIZE", newSViv(DRIZZLE_MAX_PACKET_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_BUFFER_SIZE", newSViv(DRIZZLE_MAX_BUFFER_SIZE));
    newCONSTSUB(stash, "DRIZZLE_BUFFER_COPY_THRESHOLD", newSViv(DRIZZLE_BUFFER_COPY_THRESHOLD));
    newCONSTSUB(stash, "DRIZZLE_MAX_SERVER_VERSION_SIZE", newSViv(DRIZZLE_MAX_SERVER_VERSION_SIZE));
    newCONSTSUB(stash, "DRIZZLE_MAX_SCRAMBLE_SIZE", newSViv(DRIZZLE_MAX_SCRAMBLE_SIZE));
    newCONSTSUB(stash, "DRIZZLE_STATE_STACK_SIZE", newSViv(DRIZZLE_STATE_STACK_SIZE));
    newCONSTSUB(stash, "DRIZZLE_ROW_GROW_SIZE", newSViv(DRIZZLE_ROW_GROW_SIZE));
    newCONSTSUB(stash, "DRIZZLE_DEFAULT_SOCKET_TIMEOUT", newSViv(DRIZZLE_DEFAULT_SOCKET_TIMEOUT));
    newCONSTSUB(stash, "DRIZZLE_DEFAULT_SOCKET_SEND_SIZE", newSViv(DRIZZLE_DEFAULT_SOCKET_SEND_SIZE));
    newCONSTSUB(stash, "DRIZZLE_DEFAULT_SOCKET_RECV_SIZE", newSViv(DRIZZLE_DEFAULT_SOCKET_RECV_SIZE));
    newCONSTSUB(stash, "DRIZZLE_RETURN_OK", newSViv(DRIZZLE_RETURN_OK));
    newCONSTSUB(stash, "DRIZZLE_RETURN_IO_WAIT", newSViv(DRIZZLE_RETURN_IO_WAIT));
    newCONSTSUB(stash, "DRIZZLE_RETURN_PAUSE", newSViv(DRIZZLE_RETURN_PAUSE));
    newCONSTSUB(stash, "DRIZZLE_RETURN_ROW_BREAK", newSViv(DRIZZLE_RETURN_ROW_BREAK));
    newCONSTSUB(stash, "DRIZZLE_RETURN_MEMORY", newSViv(DRIZZLE_RETURN_MEMORY));
    newCONSTSUB(stash, "DRIZZLE_RETURN_ERRNO", newSViv(DRIZZLE_RETURN_ERRNO));
    newCONSTSUB(stash, "DRIZZLE_RETURN_INTERNAL_ERROR", newSViv(DRIZZLE_RETURN_INTERNAL_ERROR));
    newCONSTSUB(stash, "DRIZZLE_RETURN_GETADDRINFO", newSViv(DRIZZLE_RETURN_GETADDRINFO));
    newCONSTSUB(stash, "DRIZZLE_RETURN_NOT_READY", newSViv(DRIZZLE_RETURN_NOT_READY));
    newCONSTSUB(stash, "DRIZZLE_RETURN_BAD_PACKET_NUMBER", newSViv(DRIZZLE_RETURN_BAD_PACKET_NUMBER));
    newCONSTSUB(stash, "DRIZZLE_RETURN_BAD_HANDSHAKE_PACKET", newSViv(DRIZZLE_RETURN_BAD_HANDSHAKE_PACKET));
    newCONSTSUB(stash, "DRIZZLE_RETURN_BAD_PACKET", newSViv(DRIZZLE_RETURN_BAD_PACKET));
    newCONSTSUB(stash, "DRIZZLE_RETURN_PROTOCOL_NOT_SUPPORTED", newSViv(DRIZZLE_RETURN_PROTOCOL_NOT_SUPPORTED));
    newCONSTSUB(stash, "DRIZZLE_RETURN_UNEXPECTED_DATA", newSViv(DRIZZLE_RETURN_UNEXPECTED_DATA));
    newCONSTSUB(stash, "DRIZZLE_RETURN_NO_SCRAMBLE", newSViv(DRIZZLE_RETURN_NO_SCRAMBLE));
    newCONSTSUB(stash, "DRIZZLE_RETURN_AUTH_FAILED", newSViv(DRIZZLE_RETURN_AUTH_FAILED));
    newCONSTSUB(stash, "DRIZZLE_RETURN_NULL_SIZE", newSViv(DRIZZLE_RETURN_NULL_SIZE));
    newCONSTSUB(stash, "DRIZZLE_RETURN_ERROR_CODE", newSViv(DRIZZLE_RETURN_ERROR_CODE));
    newCONSTSUB(stash, "DRIZZLE_RETURN_TOO_MANY_COLUMNS", newSViv(DRIZZLE_RETURN_TOO_MANY_COLUMNS));
    newCONSTSUB(stash, "DRIZZLE_RETURN_ROW_END", newSViv(DRIZZLE_RETURN_ROW_END));
    newCONSTSUB(stash, "DRIZZLE_RETURN_LOST_CONNECTION", newSViv(DRIZZLE_RETURN_LOST_CONNECTION));
    newCONSTSUB(stash, "DRIZZLE_RETURN_COULD_NOT_CONNECT", newSViv(DRIZZLE_RETURN_COULD_NOT_CONNECT));
    newCONSTSUB(stash, "DRIZZLE_RETURN_NO_ACTIVE_CONNECTIONS", newSViv(DRIZZLE_RETURN_NO_ACTIVE_CONNECTIONS));
    newCONSTSUB(stash, "DRIZZLE_RETURN_HANDSHAKE_FAILED", newSViv(DRIZZLE_RETURN_HANDSHAKE_FAILED));
    newCONSTSUB(stash, "DRIZZLE_RETURN_MAX", newSViv(DRIZZLE_RETURN_MAX));
    newCONSTSUB(stash, "DRIZZLE_RETURN_SERVER_GONE", newSViv(DRIZZLE_RETURN_SERVER_GONE));
    newCONSTSUB(stash, "DRIZZLE_RETURN_SERVER_GONE", newSViv(DRIZZLE_RETURN_SERVER_GONE));
    newCONSTSUB(stash, "DRIZZLE_RETURN_LOST_CONNECTION", newSViv(DRIZZLE_RETURN_LOST_CONNECTION));
    newCONSTSUB(stash, "DRIZZLE_RETURN_EOF", newSViv(DRIZZLE_RETURN_EOF));
    newCONSTSUB(stash, "DRIZZLE_RETURN_LOST_CONNECTION", newSViv(DRIZZLE_RETURN_LOST_CONNECTION));
    newCONSTSUB(stash, "DRIZZLE_NONE", newSViv(DRIZZLE_NONE));
    newCONSTSUB(stash, "DRIZZLE_ALLOCATED", newSViv(DRIZZLE_ALLOCATED));
    newCONSTSUB(stash, "DRIZZLE_NON_BLOCKING", newSViv(DRIZZLE_NON_BLOCKING));
    newCONSTSUB(stash, "DRIZZLE_AUTO_ALLOCATED", newSViv(DRIZZLE_AUTO_ALLOCATED));
    newCONSTSUB(stash, "DRIZZLE_CON_NONE", newSViv(DRIZZLE_CON_NONE));
    newCONSTSUB(stash, "DRIZZLE_CON_ALLOCATED", newSViv(DRIZZLE_CON_ALLOCATED));
    newCONSTSUB(stash, "DRIZZLE_CON_MYSQL", newSViv(DRIZZLE_CON_MYSQL));
    newCONSTSUB(stash, "DRIZZLE_CON_RAW_PACKET", newSViv(DRIZZLE_CON_RAW_PACKET));
    newCONSTSUB(stash, "DRIZZLE_CON_RAW_SCRAMBLE", newSViv(DRIZZLE_CON_RAW_SCRAMBLE));
    newCONSTSUB(stash, "DRIZZLE_CON_READY", newSViv(DRIZZLE_CON_READY));
    newCONSTSUB(stash, "DRIZZLE_CON_NO_RESULT_READ", newSViv(DRIZZLE_CON_NO_RESULT_READ));
    newCONSTSUB(stash, "DRIZZLE_CON_IO_READY", newSViv(DRIZZLE_CON_IO_READY));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_NONE", newSViv(DRIZZLE_CON_STATUS_NONE));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_IN_TRANS", newSViv(DRIZZLE_CON_STATUS_IN_TRANS));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_AUTOCOMMIT", newSViv(DRIZZLE_CON_STATUS_AUTOCOMMIT));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_MORE_RESULTS_EXISTS", newSViv(DRIZZLE_CON_STATUS_MORE_RESULTS_EXISTS));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_QUERY_NO_GOOD_INDEX_USED", newSViv(DRIZZLE_CON_STATUS_QUERY_NO_GOOD_INDEX_USED));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_QUERY_NO_INDEX_USED", newSViv(DRIZZLE_CON_STATUS_QUERY_NO_INDEX_USED));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_CURSOR_EXISTS", newSViv(DRIZZLE_CON_STATUS_CURSOR_EXISTS));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_LAST_ROW_SENT", newSViv(DRIZZLE_CON_STATUS_LAST_ROW_SENT));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_DB_DROPPED", newSViv(DRIZZLE_CON_STATUS_DB_DROPPED));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_NO_BACKSLASH_ESCAPES", newSViv(DRIZZLE_CON_STATUS_NO_BACKSLASH_ESCAPES));
    newCONSTSUB(stash, "DRIZZLE_CON_STATUS_QUERY_WAS_SLOW", newSViv(DRIZZLE_CON_STATUS_QUERY_WAS_SLOW));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_NONE", newSViv(DRIZZLE_CAPABILITIES_NONE));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_LONG_PASSWORD", newSViv(DRIZZLE_CAPABILITIES_LONG_PASSWORD));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_FOUND_ROWS", newSViv(DRIZZLE_CAPABILITIES_FOUND_ROWS));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_LONG_FLAG", newSViv(DRIZZLE_CAPABILITIES_LONG_FLAG));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_CONNECT_WITH_DB", newSViv(DRIZZLE_CAPABILITIES_CONNECT_WITH_DB));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_NO_SCHEMA", newSViv(DRIZZLE_CAPABILITIES_NO_SCHEMA));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_COMPRESS", newSViv(DRIZZLE_CAPABILITIES_COMPRESS));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_ODBC", newSViv(DRIZZLE_CAPABILITIES_ODBC));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_LOCAL_FILES", newSViv(DRIZZLE_CAPABILITIES_LOCAL_FILES));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_IGNORE_SPACE", newSViv(DRIZZLE_CAPABILITIES_IGNORE_SPACE));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_PROTOCOL_41", newSViv(DRIZZLE_CAPABILITIES_PROTOCOL_41));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_INTERACTIVE", newSViv(DRIZZLE_CAPABILITIES_INTERACTIVE));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_SSL", newSViv(DRIZZLE_CAPABILITIES_SSL));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_IGNORE_SIGPIPE", newSViv(DRIZZLE_CAPABILITIES_IGNORE_SIGPIPE));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_TRANSACTIONS", newSViv(DRIZZLE_CAPABILITIES_TRANSACTIONS));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_RESERVED", newSViv(DRIZZLE_CAPABILITIES_RESERVED));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_SECURE_CONNECTION", newSViv(DRIZZLE_CAPABILITIES_SECURE_CONNECTION));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_MULTI_STATEMENTS", newSViv(DRIZZLE_CAPABILITIES_MULTI_STATEMENTS));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_MULTI_RESULTS", newSViv(DRIZZLE_CAPABILITIES_MULTI_RESULTS));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_SSL_VERIFY_SERVER_CERT", newSViv(DRIZZLE_CAPABILITIES_SSL_VERIFY_SERVER_CERT));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_REMEMBER_OPTIONS", newSViv(DRIZZLE_CAPABILITIES_REMEMBER_OPTIONS));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_CLIENT", newSViv(DRIZZLE_CAPABILITIES_CLIENT));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_LONG_PASSWORD", newSViv(DRIZZLE_CAPABILITIES_LONG_PASSWORD));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_LONG_FLAG", newSViv(DRIZZLE_CAPABILITIES_LONG_FLAG));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_CONNECT_WITH_DB", newSViv(DRIZZLE_CAPABILITIES_CONNECT_WITH_DB));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_TRANSACTIONS", newSViv(DRIZZLE_CAPABILITIES_TRANSACTIONS));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_PROTOCOL_41", newSViv(DRIZZLE_CAPABILITIES_PROTOCOL_41));
    newCONSTSUB(stash, "DRIZZLE_CAPABILITIES_SECURE_CONNECTION", newSViv(DRIZZLE_CAPABILITIES_SECURE_CONNECTION));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_SLEEP", newSViv(DRIZZLE_COMMAND_SLEEP));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_QUIT", newSViv(DRIZZLE_COMMAND_QUIT));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_INIT_DB", newSViv(DRIZZLE_COMMAND_INIT_DB));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_QUERY", newSViv(DRIZZLE_COMMAND_QUERY));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_FIELD_LIST", newSViv(DRIZZLE_COMMAND_FIELD_LIST));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_CREATE_DB", newSViv(DRIZZLE_COMMAND_CREATE_DB));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DROP_DB", newSViv(DRIZZLE_COMMAND_DROP_DB));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_REFRESH", newSViv(DRIZZLE_COMMAND_REFRESH));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_SHUTDOWN", newSViv(DRIZZLE_COMMAND_SHUTDOWN));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_STATISTICS", newSViv(DRIZZLE_COMMAND_STATISTICS));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_PROCESS_INFO", newSViv(DRIZZLE_COMMAND_PROCESS_INFO));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_CONNECT", newSViv(DRIZZLE_COMMAND_CONNECT));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_PROCESS_KILL", newSViv(DRIZZLE_COMMAND_PROCESS_KILL));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DEBUG", newSViv(DRIZZLE_COMMAND_DEBUG));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_PING", newSViv(DRIZZLE_COMMAND_PING));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_TIME", newSViv(DRIZZLE_COMMAND_TIME));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DELAYED_INSERT", newSViv(DRIZZLE_COMMAND_DELAYED_INSERT));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_CHANGE_USER", newSViv(DRIZZLE_COMMAND_CHANGE_USER));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_BINLOG_DUMP", newSViv(DRIZZLE_COMMAND_BINLOG_DUMP));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_TABLE_DUMP", newSViv(DRIZZLE_COMMAND_TABLE_DUMP));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_CONNECT_OUT", newSViv(DRIZZLE_COMMAND_CONNECT_OUT));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_REGISTER_SLAVE", newSViv(DRIZZLE_COMMAND_REGISTER_SLAVE));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_STMT_PREPARE", newSViv(DRIZZLE_COMMAND_STMT_PREPARE));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_STMT_EXECUTE", newSViv(DRIZZLE_COMMAND_STMT_EXECUTE));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_STMT_SEND_LONG_DATA", newSViv(DRIZZLE_COMMAND_STMT_SEND_LONG_DATA));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_STMT_CLOSE", newSViv(DRIZZLE_COMMAND_STMT_CLOSE));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_STMT_RESET", newSViv(DRIZZLE_COMMAND_STMT_RESET));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_SET_OPTION", newSViv(DRIZZLE_COMMAND_SET_OPTION));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_STMT_FETCH", newSViv(DRIZZLE_COMMAND_STMT_FETCH));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DAEMON", newSViv(DRIZZLE_COMMAND_DAEMON));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_END", newSViv(DRIZZLE_COMMAND_END));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DRIZZLE_SLEEP", newSViv(DRIZZLE_COMMAND_DRIZZLE_SLEEP));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DRIZZLE_QUIT", newSViv(DRIZZLE_COMMAND_DRIZZLE_QUIT));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DRIZZLE_INIT_DB", newSViv(DRIZZLE_COMMAND_DRIZZLE_INIT_DB));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DRIZZLE_QUERY", newSViv(DRIZZLE_COMMAND_DRIZZLE_QUERY));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DRIZZLE_SHUTDOWN", newSViv(DRIZZLE_COMMAND_DRIZZLE_SHUTDOWN));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DRIZZLE_CONNECT", newSViv(DRIZZLE_COMMAND_DRIZZLE_CONNECT));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DRIZZLE_PING", newSViv(DRIZZLE_COMMAND_DRIZZLE_PING));
    newCONSTSUB(stash, "DRIZZLE_COMMAND_DRIZZLE_END", newSViv(DRIZZLE_COMMAND_DRIZZLE_END));
    newCONSTSUB(stash, "DRIZZLE_REFRESH_GRANT", newSViv(DRIZZLE_REFRESH_GRANT));
    newCONSTSUB(stash, "DRIZZLE_REFRESH_LOG", newSViv(DRIZZLE_REFRESH_LOG));
    newCONSTSUB(stash, "DRIZZLE_REFRESH_TABLES", newSViv(DRIZZLE_REFRESH_TABLES));
    newCONSTSUB(stash, "DRIZZLE_REFRESH_HOSTS", newSViv(DRIZZLE_REFRESH_HOSTS));
    newCONSTSUB(stash, "DRIZZLE_REFRESH_STATUS", newSViv(DRIZZLE_REFRESH_STATUS));
    newCONSTSUB(stash, "DRIZZLE_REFRESH_THREADS", newSViv(DRIZZLE_REFRESH_THREADS));
    newCONSTSUB(stash, "DRIZZLE_REFRESH_SLAVE", newSViv(DRIZZLE_REFRESH_SLAVE));
    newCONSTSUB(stash, "DRIZZLE_REFRESH_MASTER", newSViv(DRIZZLE_REFRESH_MASTER));
    newCONSTSUB(stash, "DRIZZLE_SHUTDOWN_DEFAULT", newSViv(DRIZZLE_SHUTDOWN_DEFAULT));
    newCONSTSUB(stash, "DRIZZLE_SHUTDOWN_WAIT_CONNECTIONS", newSViv(DRIZZLE_SHUTDOWN_WAIT_CONNECTIONS));
    newCONSTSUB(stash, "DRIZZLE_SHUTDOWN_WAIT_TRANSACTIONS", newSViv(DRIZZLE_SHUTDOWN_WAIT_TRANSACTIONS));
    newCONSTSUB(stash, "DRIZZLE_SHUTDOWN_WAIT_UPDATES", newSViv(DRIZZLE_SHUTDOWN_WAIT_UPDATES));
    newCONSTSUB(stash, "DRIZZLE_SHUTDOWN_WAIT_ALL_BUFFERS", newSViv(DRIZZLE_SHUTDOWN_WAIT_ALL_BUFFERS));
    newCONSTSUB(stash, "DRIZZLE_SHUTDOWN_WAIT_CRITICAL_BUFFERS", newSViv(DRIZZLE_SHUTDOWN_WAIT_CRITICAL_BUFFERS));
    newCONSTSUB(stash, "DRIZZLE_SHUTDOWN_KILL_QUERY", newSViv(DRIZZLE_SHUTDOWN_KILL_QUERY));
    newCONSTSUB(stash, "DRIZZLE_SHUTDOWN_KILL_CONNECTION", newSViv(DRIZZLE_SHUTDOWN_KILL_CONNECTION));
    newCONSTSUB(stash, "DRIZZLE_QUERY_ALLOCATED", newSViv(DRIZZLE_QUERY_ALLOCATED));
    newCONSTSUB(stash, "DRIZZLE_QUERY_STATE_INIT", newSViv(DRIZZLE_QUERY_STATE_INIT));
    newCONSTSUB(stash, "DRIZZLE_QUERY_STATE_QUERY", newSViv(DRIZZLE_QUERY_STATE_QUERY));
    newCONSTSUB(stash, "DRIZZLE_QUERY_STATE_RESULT", newSViv(DRIZZLE_QUERY_STATE_RESULT));
    newCONSTSUB(stash, "DRIZZLE_QUERY_STATE_DONE", newSViv(DRIZZLE_QUERY_STATE_DONE));
    newCONSTSUB(stash, "DRIZZLE_RESULT_NONE", newSViv(DRIZZLE_RESULT_NONE));
    newCONSTSUB(stash, "DRIZZLE_RESULT_ALLOCATED", newSViv(DRIZZLE_RESULT_ALLOCATED));
    newCONSTSUB(stash, "DRIZZLE_RESULT_SKIP_COLUMN", newSViv(DRIZZLE_RESULT_SKIP_COLUMN));
    newCONSTSUB(stash, "DRIZZLE_RESULT_BUFFER_COLUMN", newSViv(DRIZZLE_RESULT_BUFFER_COLUMN));
    newCONSTSUB(stash, "DRIZZLE_RESULT_BUFFER_ROW", newSViv(DRIZZLE_RESULT_BUFFER_ROW));
    newCONSTSUB(stash, "DRIZZLE_RESULT_EOF_PACKET", newSViv(DRIZZLE_RESULT_EOF_PACKET));
    newCONSTSUB(stash, "DRIZZLE_RESULT_ROW_BREAK", newSViv(DRIZZLE_RESULT_ROW_BREAK));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_ALLOCATED", newSViv(DRIZZLE_COLUMN_ALLOCATED));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DECIMAL", newSViv(DRIZZLE_COLUMN_TYPE_DECIMAL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_TINY", newSViv(DRIZZLE_COLUMN_TYPE_TINY));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_SHORT", newSViv(DRIZZLE_COLUMN_TYPE_SHORT));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_LONG", newSViv(DRIZZLE_COLUMN_TYPE_LONG));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_FLOAT", newSViv(DRIZZLE_COLUMN_TYPE_FLOAT));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DOUBLE", newSViv(DRIZZLE_COLUMN_TYPE_DOUBLE));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_NULL", newSViv(DRIZZLE_COLUMN_TYPE_NULL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_TIMESTAMP", newSViv(DRIZZLE_COLUMN_TYPE_TIMESTAMP));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_LONGLONG", newSViv(DRIZZLE_COLUMN_TYPE_LONGLONG));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_INT24", newSViv(DRIZZLE_COLUMN_TYPE_INT24));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DATE", newSViv(DRIZZLE_COLUMN_TYPE_DATE));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_TIME", newSViv(DRIZZLE_COLUMN_TYPE_TIME));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DATETIME", newSViv(DRIZZLE_COLUMN_TYPE_DATETIME));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_YEAR", newSViv(DRIZZLE_COLUMN_TYPE_YEAR));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_NEWDATE", newSViv(DRIZZLE_COLUMN_TYPE_NEWDATE));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_VARCHAR", newSViv(DRIZZLE_COLUMN_TYPE_VARCHAR));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_BIT", newSViv(DRIZZLE_COLUMN_TYPE_BIT));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_VIRTUAL", newSViv(DRIZZLE_COLUMN_TYPE_VIRTUAL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_NEWDECIMAL", newSViv(DRIZZLE_COLUMN_TYPE_NEWDECIMAL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_ENUM", newSViv(DRIZZLE_COLUMN_TYPE_ENUM));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_SET", newSViv(DRIZZLE_COLUMN_TYPE_SET));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_TINY_BLOB", newSViv(DRIZZLE_COLUMN_TYPE_TINY_BLOB));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_MEDIUM_BLOB", newSViv(DRIZZLE_COLUMN_TYPE_MEDIUM_BLOB));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_LONG_BLOB", newSViv(DRIZZLE_COLUMN_TYPE_LONG_BLOB));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_BLOB", newSViv(DRIZZLE_COLUMN_TYPE_BLOB));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_VAR_STRING", newSViv(DRIZZLE_COLUMN_TYPE_VAR_STRING));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_STRING", newSViv(DRIZZLE_COLUMN_TYPE_STRING));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_GEOMETRY", newSViv(DRIZZLE_COLUMN_TYPE_GEOMETRY));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_TINY", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_TINY));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_LONG", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_LONG));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_DOUBLE", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_DOUBLE));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_NULL", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_NULL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_TIMESTAMP", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_TIMESTAMP));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_LONGLONG", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_LONGLONG));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_DATETIME", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_DATETIME));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_DATE", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_DATE));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_VARCHAR", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_VARCHAR));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_VIRTUAL", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_VIRTUAL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_NEWDECIMAL", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_NEWDECIMAL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_ENUM", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_ENUM));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_BLOB", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_BLOB));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_MAX", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_MAX));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_TYPE_DRIZZLE_BLOB", newSViv(DRIZZLE_COLUMN_TYPE_DRIZZLE_BLOB));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_NONE", newSViv(DRIZZLE_COLUMN_FLAGS_NONE));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_NOT_NULL", newSViv(DRIZZLE_COLUMN_FLAGS_NOT_NULL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_PRI_KEY", newSViv(DRIZZLE_COLUMN_FLAGS_PRI_KEY));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_UNIQUE_KEY", newSViv(DRIZZLE_COLUMN_FLAGS_UNIQUE_KEY));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_MULTIPLE_KEY", newSViv(DRIZZLE_COLUMN_FLAGS_MULTIPLE_KEY));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_BLOB", newSViv(DRIZZLE_COLUMN_FLAGS_BLOB));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_UNSIGNED", newSViv(DRIZZLE_COLUMN_FLAGS_UNSIGNED));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_ZEROFILL", newSViv(DRIZZLE_COLUMN_FLAGS_ZEROFILL));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_BINARY", newSViv(DRIZZLE_COLUMN_FLAGS_BINARY));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_ENUM", newSViv(DRIZZLE_COLUMN_FLAGS_ENUM));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_AUTO_INCREMENT", newSViv(DRIZZLE_COLUMN_FLAGS_AUTO_INCREMENT));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_TIMESTAMP", newSViv(DRIZZLE_COLUMN_FLAGS_TIMESTAMP));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_SET", newSViv(DRIZZLE_COLUMN_FLAGS_SET));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_NO_DEFAULT_VALUE", newSViv(DRIZZLE_COLUMN_FLAGS_NO_DEFAULT_VALUE));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_ON_UPDATE_NOW", newSViv(DRIZZLE_COLUMN_FLAGS_ON_UPDATE_NOW));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_PART_KEY", newSViv(DRIZZLE_COLUMN_FLAGS_PART_KEY));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_NUM", newSViv(DRIZZLE_COLUMN_FLAGS_NUM));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_GROUP", newSViv(DRIZZLE_COLUMN_FLAGS_GROUP));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_UNIQUE", newSViv(DRIZZLE_COLUMN_FLAGS_UNIQUE));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_BINCMP", newSViv(DRIZZLE_COLUMN_FLAGS_BINCMP));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_GET_FIXED_FIELDS", newSViv(DRIZZLE_COLUMN_FLAGS_GET_FIXED_FIELDS));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_IN_PART_FUNC", newSViv(DRIZZLE_COLUMN_FLAGS_IN_PART_FUNC));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_IN_ADD_INDEX", newSViv(DRIZZLE_COLUMN_FLAGS_IN_ADD_INDEX));
    newCONSTSUB(stash, "DRIZZLE_COLUMN_FLAGS_RENAMED", newSViv(DRIZZLE_COLUMN_FLAGS_RENAMED));

drizzle_st*
Net::Drizzle::new()
CODE:
    drizzle_st * self;
    if ((self = drizzle_create(NULL)) == NULL) {
        Perl_croak(aTHX_ "drizzle_create:NULL\n");
    }
    RETVAL = self;
OUTPUT:
    RETVAL

net_con*
con_create(SV *self)
CODE:
    net_con *con;
    Newxz(con, 1, net_con);
    con->drizzle = self;
    LOG("CREATE con 0x%X, 0x%X(con_create)\n", (unsigned int)self, (unsigned int)con->drizzle);
    SvREFCNT_inc(self);
    drizzle_st * drizzle = XS_STATE(drizzle_st*, self);
    if ((con->con = drizzle_con_create(drizzle, NULL)) == NULL) {
        Perl_croak(aTHX_ "drizzle_con_create:NULL\n");
    }
    RETVAL = con;
OUTPUT:
    RETVAL

void
DESTROY(SV* _self)
CODE:
    LOG("DESTROY drizzle 0x%X\n", (unsigned int)_self);
    drizzle_st *drizzle = XS_STATE(drizzle_st*, _self);
    drizzle_free(drizzle); // wtf? this cause segv.

void
query_run_all(drizzle_st *self)
CODE:
    drizzle_return_t ret = drizzle_query_run_all(self);
    if (ret != DRIZZLE_RETURN_OK) {
        Perl_croak(aTHX_ "drizzle_query_run_all:%s\n", drizzle_error(self));
    }

SV *
escape(SV *class, SV* str)
CODE:
    STRLEN str_len;
    const char * str_c = SvPV(str, str_len);
    char * buf;
    Newxz(buf, str_len*2+1, char);
    uint64_t dst_len = drizzle_escape_string(buf, str_c, str_len);
    RETVAL = newSVpvn(buf, dst_len);
OUTPUT:
    RETVAL

const char *
drizzle_version(SV *class)
CODE:
    RETVAL = drizzle_version();
OUTPUT:
    RETVAL

MODULE = Net::Drizzle  PACKAGE = Net::Drizzle::Connection

net_con*
Net::Drizzle::Connection::new()
CODE:
    net_con * self;
    Newxz(self, 1, net_con);

    drizzle_st * drizzle;
    if ((drizzle = drizzle_create(NULL)) == NULL) {
        Perl_croak(aTHX_ "drizzle_create:NULL\n");
    }
    if ((self->con = drizzle_con_create(drizzle, NULL)) == NULL) {
        Perl_croak(aTHX_ "drizzle_con_create:NULL\n");
    }

	SV * ret = newSViv(0);
    XS_STRUCT2OBJ(ret, "Net::Drizzle", drizzle);
    self->drizzle = ret;
    RETVAL = self;
OUTPUT:
    RETVAL

SV*
set_db(SV* self, const char *db)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_db(con->con, db);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_protocol_version(SV* self, U8 protocol_version)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_protocol_version(con->con, protocol_version);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_scramble(SV* self, unsigned char* scramble)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_scramble(con->con, scramble);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_status(SV* self, int status)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_status(con->con, status);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_capabilities(SV* self, int capabilities)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_capabilities(con->con, capabilities);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_charset(SV* self, U8 charset)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_charset(con->con, charset);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_thread_id(SV* self, U32 protocol_version)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_thread_id(con->con, protocol_version);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_max_packet_size(SV* self, U32 protocol_version)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_max_packet_size(con->con, protocol_version);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

void
server_handshake_write(SV* self)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_return_t ret = drizzle_server_handshake_write(con->con);
    if (ret != DRIZZLE_RETURN_OK) {
        drizzle_st *drizzle = drizzle_con_drizzle(con->con);
        Perl_croak(aTHX_ "drizzle_server_handshake_write:%s\n", drizzle_error(drizzle));
    }

void
client_handshake_read(SV*self)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_return_t ret = drizzle_client_handshake_read(con->con);
    if (ret != DRIZZLE_RETURN_OK) {
        drizzle_st *drizzle = drizzle_con_drizzle(con->con);
        Perl_croak(aTHX_ "drizzle_client_handshake_read:%s\n", drizzle_error(drizzle));
    }

SV*
set_server_version(SV* self, const char* server_version)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_server_version(con->con, server_version);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_fd(SV* self, int fd)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_return_t ret = drizzle_con_set_fd(con->con, fd);
    if (ret != DRIZZLE_RETURN_OK) {
        drizzle_st *drizzle = drizzle_con_drizzle(con->con);
        Perl_croak(aTHX_ "drizzle_con_set_fd:%s\n", drizzle_error(drizzle));
    }
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

net_sth*
result_create(SV *_self)
CODE:
    net_con * con = XS_STATE(net_con*, _self);
    net_sth * sth;
    drizzle_result_st *result = drizzle_result_create(con->con, NULL);
    if (result == NULL) {
        drizzle_st *drizzle = drizzle_con_drizzle(con->con);
        Perl_croak(aTHX_ "drizzle_result_create:%s\n", drizzle_error(drizzle));
    }
    printf("%d\n", result->options);
    Newxz(sth, 1, net_sth);
    sth->drizzle = con->drizzle;
    sth->result = result;
    sth->con = _self;
    sth->query = NULL;
    SvREFCNT_inc_simple_void(sth->drizzle);
    SvREFCNT_inc_simple_void(_self);
    RETVAL = sth;
OUTPUT:
    RETVAL

void
command_buffer(net_con *con)
PPCODE:
    /* my ($data, $command, $total, $ret) = $con->command_buffer(); */
    drizzle_command_t command;
    size_t total;
    drizzle_return_t ret;
    uint8_t *data = NULL;

    data = drizzle_command_buffer(con->con, &command, &total, &ret);

    mXPUSHp((const char *)data, data ? strlen((char*)data) : 0);
    mXPUSHi(command);
    mXPUSHi(total);
    mXPUSHi(ret);
    XSRETURN(4);

int
fd(net_con * con)
CODE:
    int fd = drizzle_con_fd(con->con);
    RETVAL = fd;
OUTPUT:
    RETVAL

const char *
host(net_con* self)
CODE:
    RETVAL = drizzle_con_host(self->con);
OUTPUT:
    RETVAL

const char *
user(net_con* self)
CODE:
    RETVAL = drizzle_con_user(self->con);
OUTPUT:
    RETVAL

const char *
password(net_con* self)
CODE:
    RETVAL = drizzle_con_password(self->con);
OUTPUT:
    RETVAL

U16
port(net_con* self)
CODE:
    RETVAL = drizzle_con_port(self->con);
OUTPUT:
    RETVAL

SV *
set_tcp(SV* self, const char *host, U16 port)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_tcp(con->con, host, port);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_auth(SV* self, const char *user, const char* password)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_auth(con->con, user, password);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
add_options(SV* self, int opt)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_add_options(con->con, opt);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

net_con*
clone(net_con* self)
CODE:
    net_con *con;
    Newxz(con, 1, net_con);
    con->drizzle = self->drizzle;
    SvREFCNT_inc(self->drizzle);
    drizzle_st * drizzle = XS_STATE(drizzle_st*, self->drizzle);
    if ((con->con = drizzle_con_clone(drizzle, NULL, self->con)) == NULL) {
        Perl_croak(aTHX_ "drizzle_con_clone:%s\n", drizzle_error(drizzle));
    }
    RETVAL = con;
OUTPUT:
    RETVAL

net_sth*
query_add(SV *_self, SV *query)
CODE:
    net_con * self = XS_STATE(net_con*, _self);
    drizzle_st * drizzle = XS_STATE(drizzle_st*, self->drizzle);
    size_t query_len;
    const char* query_c = SvPV(query, query_len);
    net_sth *sth;
    LOG("CREATE query 0x%X\n", (unsigned int)self->drizzle);
    Newxz(sth, 1, net_sth);
    sth->drizzle = self->drizzle;
    sth->con = _self;
    SvREFCNT_inc(sth->drizzle);
    SvREFCNT_inc_simple_void(_self);
    LOG("CREATE query 0x%X\n", (unsigned int)self->drizzle);
    if ((sth->query = drizzle_query_add(drizzle, NULL, self->con, NULL, query_c,
                              query_len, (drizzle_query_options_t)0, NULL)) == NULL) {
         Perl_croak(aTHX_ "drizzle_query_add:%s\n", drizzle_error(drizzle));
    }
    sth->result = NULL;
    RETVAL = sth;
OUTPUT:
    RETVAL

net_sth*
query_str(SV *_self, const char*query)
CODE:
    net_con * self = XS_STATE(net_con*, _self);
    LOG("CREATE query_sth 0x%X\n", (unsigned int)self->drizzle);
    drizzle_st * drizzle = XS_STATE(drizzle_st*, self->drizzle);

    net_sth *sth;
    Newxz(sth, 1, net_sth);
    sth->drizzle = self->drizzle;
    sth->con = _self;
    SvREFCNT_inc_simple_void(sth->drizzle);
    SvREFCNT_inc_simple_void(_self);

    drizzle_return_t ret;
    sth->query = NULL;
    sth->result = drizzle_query_str(self->con, NULL, query, &ret);
    if (ret != DRIZZLE_RETURN_OK) {
        Perl_croak(aTHX_ "drizzle_query_str:%s\n", drizzle_error(drizzle));
    }
    RETVAL=sth;
OUTPUT:
    RETVAL

void
DESTROY(SV *_self)
CODE:
    net_con * self = XS_STATE(net_con*, _self);
    LOG("DESTROY connection 0x%X\n", (unsigned int)self->drizzle);

    if (self->drizzle != NULL) {
         SvREFCNT_dec(self->drizzle);
    } else {
        LOG("FREE connection\n");
        drizzle_con_free(self->con);
    }
    Safefree(self);

MODULE = Net::Drizzle  PACKAGE = Net::Drizzle::Result

int
error_code(net_sth *self)
CODE:
    DEF_RESULT(self);
    RETVAL = drizzle_result_error_code(result);
OUTPUT:
    RETVAL

const char*
error(net_sth *self)
CODE:
    DEF_RESULT(self);
    RETVAL = drizzle_result_error(result);
OUTPUT:
    RETVAL

const char*
info(net_sth *self)
CODE:
    DEF_RESULT(self);
    RETVAL = drizzle_result_info(result);
OUTPUT:
    RETVAL

unsigned int
column_count(net_sth *self)
CODE:
    DEF_RESULT(self);
    RETVAL = drizzle_result_column_count(result);
OUTPUT:
    RETVAL

void
buffer(net_sth *self)
CODE:
    DEF_RESULT(self);
    drizzle_return_t ret = drizzle_result_buffer(result);
    if (ret != DRIZZLE_RETURN_OK) {
        drizzle_con_st * con = drizzle_result_drizzle_con(result);
        drizzle_st * drizzle = drizzle_con_drizzle(con);
        Perl_croak(aTHX_ "drizzle_result_buffer:%s\n", drizzle_error(drizzle));
    }

SV *
set_eof(SV *self_sv, bool eof)
CODE:
    net_sth * self_sth = XS_STATE(net_sth *, self_sv);
    DEF_RESULT(self_sth);
    drizzle_result_set_eof(result, eof);
    RETVAL = SvREFCNT_inc_simple(self_sv);
OUTPUT:
    RETVAL

SV *
write(SV *self_sv, bool flush)
CODE:
    net_sth * self_sth = XS_STATE(net_sth *, self_sv);
    DEF_RESULT(self_sth);
    drizzle_con_st * con = drizzle_result_drizzle_con(result);
    drizzle_result_write(con, result, flush);
    RETVAL = SvREFCNT_inc(self_sv);
OUTPUT:
    RETVAL

SV*
row_next(net_sth *self)
CODE:
    DEF_RESULT(self);
    AV * res = newAV();
    drizzle_row_t row = drizzle_row_next(result);
    uint16_t cnt = drizzle_result_column_count(result);
    if (row) {
        int i;
        for (i=0; i<cnt; i++) {
            SV *s = newSVpv(row[i], strlen(row[i]));
            SvREFCNT_inc_simple_void(s);
            av_push(res, s);
        }
        RETVAL = newRV_noinc((SV*)res);
    } else {
        RETVAL = &PL_sv_undef;
    }
OUTPUT:
    RETVAL

SV*
set_column_count(SV*self_sv, U16 column_count)
CODE:
    net_sth * self_sth = XS_STATE(net_sth*, self_sv);
    DEF_RESULT(self_sth);
    drizzle_result_set_column_count(result, column_count);
    RETVAL = SvREFCNT_inc(self_sv);
OUTPUT:
    RETVAL

net_col*
column_create(SV* self_sv)
CODE:
    net_sth * self_sth = XS_STATE(net_sth*, self_sv);
    DEF_RESULT(self_sth);
    drizzle_column_st *col_raw = drizzle_column_create(result, NULL);
    if (col_raw == NULL) {
        drizzle_con_st * con = drizzle_result_drizzle_con(result);
        drizzle_st * drizzle = drizzle_con_drizzle(con);
        Perl_croak(aTHX_ "drizzle_column_create:%s\n", drizzle_error(drizzle));
    }

    net_col *col;
    Newxz(col, 1, net_col);
    col->drizzle = SvREFCNT_inc_simple(self_sth->drizzle);
    col->con     = SvREFCNT_inc_simple(self_sth->con);
    col->result  = SvREFCNT_inc_simple(self_sv);
    col->col     = col_raw;
    RETVAL = col;
OUTPUT:
    RETVAL

SV*
calc_row_size(SV * self, ...)
CODE:
    net_sth *sth = XS_STATE(net_sth*, self);
    DEF_RESULT(sth);
    int i;
    size_t *sizes;
    drizzle_field_t * fields;
    Newx(sizes,  items-1, size_t);
    Newx(fields, items-1, drizzle_field_t);
    for (i=1; i<items; i++) { /* 1 means "skip SV* self" */
        STRLEN len;
        fields[i-1] = SvPV(ST(i), len);
        sizes[i-1]  = len;
        LOG("%d, %s, %d\n", i-1, fields[i-1], sizes[i-1]);
    }
    drizzle_result_calc_row_size(result, fields, sizes);
    Safefree(sizes);
    Safefree(fields);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
fields_write(SV * self, ...)
CODE:
    net_sth *sth = XS_STATE(net_sth*, self);
    DEF_RESULT(sth);
    int i;
    for (i=1; i<items; i++) { /* 1 means "skip SV* self" */
        size_t size;
        drizzle_field_t field;
        field = SvPV(ST(i), size);
        drizzle_return_t ret = drizzle_field_write(result, field, size, size);
        if (ret != DRIZZLE_RETURN_OK) {
            drizzle_con_st * con = drizzle_result_drizzle_con(result);
            drizzle_st * drizzle = drizzle_con_drizzle(con);
            Perl_croak(aTHX_ "drizzle_column_create:%s\n", drizzle_error(drizzle));
        }
    }
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

void
row_write(net_sth *sth)
CODE:
    DEF_RESULT(sth);
    drizzle_row_write(result);

void
DESTROY(net_sth *self)
CODE:
    LOG("DESTROY result 0x%X\n", (unsigned int)self->drizzle);

    if (self->drizzle != NULL) {
        SvREFCNT_dec(self->drizzle);
    }
    if (self->con != NULL) {
        SvREFCNT_dec(self->con);
    }
    Safefree(self);

MODULE = Net::Drizzle  PACKAGE = Net::Drizzle::Column


SV*
set_catalog(SV*self, const char* arg)
CODE:
    drizzle_column_set_catalog((XS_STATE(net_col*, self))->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_db(SV*self, const char* arg)
CODE:
    drizzle_column_set_db((XS_STATE(net_col*, self))->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_table(SV*self, const char* arg)
CODE:
    drizzle_column_set_table((XS_STATE(net_col*, self))->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_orig_table(SV*self, const char* arg)
CODE:
    drizzle_column_set_orig_table((XS_STATE(net_col*, self))->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_name(SV*self, const char* arg)
CODE:
    drizzle_column_set_name((XS_STATE(net_col*, self))->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_orig_name(SV*self, const char* arg)
CODE:
    drizzle_column_set_orig_name((XS_STATE(net_col*, self))->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL


SV*
set_charset(SV*self, U8 arg)
CODE:
    drizzle_column_set_charset(XS_STATE(net_col*, self)->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_size(SV*self, U32 arg)
CODE:
    drizzle_column_set_size(XS_STATE(net_col*, self)->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
set_type(SV*self, int arg)
CODE:
    drizzle_column_set_type(XS_STATE(net_col*, self)->col, arg);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

SV*
write(SV * self)
CODE:
    net_col *col = XS_STATE(net_col*, self);
    drizzle_result_st * result = drizzle_column_drizzle_result(col->col);
    drizzle_return_t ret = drizzle_column_write(result, col->col);
    if (ret != DRIZZLE_RETURN_OK) {
        drizzle_con_st * con = drizzle_result_drizzle_con(result);
        drizzle_st * drizzle = drizzle_con_drizzle(con);
        Perl_croak(aTHX_ "drizzle_column_write:%s\n", drizzle_error(drizzle));
    }
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

void
DESTROY(net_col *self)
CODE:
    LOG("DESTROY column 0x%X\n", (unsigned int)self->drizzle);

    if (self->drizzle != NULL) {
        SvREFCNT_dec(self->drizzle);
    }
    if (self->con != NULL) {
        SvREFCNT_dec(self->con);
    }
    if (self->result != NULL) {
        SvREFCNT_dec(self->result);
    }
    Safefree(self);

