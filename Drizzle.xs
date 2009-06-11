#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include <libdrizzle/drizzle_client.h>
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

#if 0
#define LOG(...) PerlIO_printf(PerlIO_stderr(), __VA_ARGS__)
#else
#define LOG(...)
#endif

#define DEF_RESULT(c) drizzle_result_st *result = (c)->result ? (c)->result : drizzle_query_result((c)->query)

#define XS_STATE(type, x) \
    INT2PTR(type, SvROK(x) ? SvIV(SvRV(x)) : SvIV(x))

#define XS_STRUCT2OBJ(sv, class, obj) \
    if (obj == NULL) { \
        sv_setsv(sv, &PL_sv_undef); \
    } else { \
        sv_setref_pv(sv, class, (void *) obj); \
    }


MODULE = Net::Drizzle  PACKAGE = Net::Drizzle

BOOT:
    HV* stash = gv_stashpvn("Net::Drizzle", strlen("Net::Drizzle"), TRUE);
    newCONSTSUB(stash, "DRIZZLE_CON_MYSQL", newSViv(DRIZZLE_CON_MYSQL));

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

MODULE = Net::Drizzle  PACKAGE = Net::Drizzle::Connection

net_con*
Net::Drizzle::Connection::new()
CODE:
    net_con * self;
    Newxz(self, 1, net_con);
    if ((self->con = drizzle_con_create(NULL, NULL)) == NULL) {
        Perl_croak(aTHX_ "drizzle_con_create:NULL\n");
    }
	SV * ret = newSViv(0);
    XS_STRUCT2OBJ(ret, "Net::Drizzle", drizzle_con_drizzle(self->con));
    self->drizzle = ret;
    RETVAL = self;
OUTPUT:
    RETVAL

void
set_db(net_con* self, const char *db)
CODE:
    drizzle_con_set_db(self->con, db);

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

void
set_tcp(net_con* self, const char *host, U16 port)
CODE:
    drizzle_con_set_tcp(self->con, host, port);

void
set_auth(net_con* self, const char *user, const char* password)
CODE:
    drizzle_con_set_auth(self->con, user, password);

void
add_options(net_con* self, int opt)
CODE:
    drizzle_con_add_options(self->con, opt);

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
        Perl_croak(aTHX_ "drizzle_query_run_all:%s\n", drizzle_error(drizzle));
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

MODULE = Net::Drizzle  PACKAGE = Net::Drizzle::Sth

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

