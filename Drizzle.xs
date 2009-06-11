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
    drizzle_con_st con;
} net_con;

typedef struct net_sth {
    SV * drizzle;
    drizzle_result_st result;
    drizzle_query_st query;
} net_sth;

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
    Newxz(self, 1, drizzle_st);
    if (drizzle_create(self) == NULL) {
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
    SvREFCNT_inc(self);
    drizzle_st * drizzle = XS_STATE(drizzle_st*, self);
    if (drizzle_con_create(drizzle, &(con->con)) == NULL) {
        Perl_croak(aTHX_ "drizzle_con_create:NULL\n");
    }
    RETVAL = con;
OUTPUT:
    RETVAL

void
DESTROY(drizzle_st* self)
CODE:
    drizzle_free(self);

void
query_run_all(drizzle_st *self)
CODE:
    drizzle_query_run_all(self);

MODULE = Net::Drizzle  PACKAGE = Net::Drizzle::Connection

void
set_db(net_con* self, const char *db)
CODE:
    drizzle_con_set_db(&(self->con), db);

void
add_options(net_con* self, int opt)
CODE:
    drizzle_con_add_options(&(self->con), opt);

net_con*
clone(net_con* self)
CODE:
    net_con *con;
    Newxz(con, 1, net_con);
    con->drizzle = self->drizzle;
    drizzle_st * drizzle = XS_STATE(drizzle_st*, self->drizzle);
    if (drizzle_con_clone(drizzle, &(con->con), &(self->con)) == NULL) {
        Perl_croak(aTHX_ "drizzle_con_clone:%s\n", drizzle_error(drizzle));
    }
    RETVAL = con;
OUTPUT:
    RETVAL

net_sth*
query_add(net_con *self, SV *query)
CODE:
    drizzle_st * drizzle = XS_STATE(drizzle_st*, self->drizzle);
    size_t query_len;
    const char* query_c = SvPV(query, query_len);
    net_sth *sth;
    Newxz(sth, 1, net_sth);
    SvREFCNT_inc(self->drizzle);
    sth->drizzle = self->drizzle;
    if (drizzle_query_add(drizzle, &(sth->query), &(self->con), &(sth->result), query_c,
                              query_len, (drizzle_query_options_t)0, NULL) == NULL) {
         Perl_croak(aTHX_ "drizzle_query_add:%s\n", drizzle_error(drizzle));
    }
    RETVAL = sth;
OUTPUT:
    RETVAL

void
DESTROY(net_con *self)
CODE:
    SvREFCNT_dec(self->drizzle);

MODULE = Net::Drizzle  PACKAGE = Net::Drizzle::Sth

int
error_code(net_sth *self)
CODE:
    RETVAL = drizzle_result_error_code(&(self->result));
OUTPUT:
    RETVAL

const char*
error(net_sth *self)
CODE:
    RETVAL = drizzle_result_error(&(self->result));
OUTPUT:
    RETVAL

const char*
info(net_sth *self)
CODE:
    RETVAL = drizzle_result_info(&(self->result));
OUTPUT:
    RETVAL

unsigned int
column_count(net_sth *self)
CODE:
    RETVAL = drizzle_result_column_count(&(self->result));
OUTPUT:
    RETVAL

SV*
next(net_sth *self)
CODE:
    AV * res = newAV();
    drizzle_row_t row = drizzle_row_next(&(self->result));
    uint16_t cnt = drizzle_result_column_count(&(self->result));
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
    // SvREFCNT_dec(self->drizzle);

