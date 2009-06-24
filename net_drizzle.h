#ifndef __NET_DRIZZLE_H__
#define __NET_DRIZZLE_H__

#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include <libdrizzle/drizzle_client.h>
#include <libdrizzle/drizzle_server.h>
#include <libdrizzle/conn.h>
#ifdef __cplusplus
}
#endif

typedef struct net_drizzle {
    drizzle_st *drizzle;
    AV * queries;
} net_drizzle;

typedef struct net_query {
    SV * drizzle;
    SV * con;
    drizzle_query_st * query;
} net_query;

typedef struct net_con {
    SV * drizzle;
    drizzle_con_st * con;
} net_con;

typedef struct net_result {
    SV * drizzle;
    SV * con;
    SV * query;
    drizzle_result_st *result;
} net_result;

typedef struct net_col {
    SV * drizzle;
    SV * con;
    SV * result;
    drizzle_column_st *col;
} net_col;

#if 0
#define LOG(...) PerlIO_printf(PerlIO_stderr(), __VA_ARGS__)
#else
#define LOG(...)
#endif

#define XS_STATE(type, x)     (INT2PTR(type, SvROK(x) ? SvIV(SvRV(x)) : SvIV(x)))

#define XS_STRUCT2OBJ(sv, class, obj)     if (obj == NULL) {         sv_setsv(sv, &PL_sv_undef);     } else {         sv_setref_pv(sv, class, (void *) obj);     }

#define GET_DRIZZLE(x)             XS_STATE(net_drizzle*, (x))->drizzle

#define GET_DRIZZLE_QUERIES(x)     (XS_STATE(net_drizzle*, (x))->queries)

#endif /* __NET_DRIZZLE_H__ */

