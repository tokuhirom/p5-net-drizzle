#include "bindpp.h"
#include <libdrizzle/drizzle_client.h>
#include <cstdlib>

typedef struct net_drizzle_c {
    drizzle_st dr;
    drizzle_con_st con;
} net_drizzle_context;

#define DEF_SELF pl::Pointer * __ptr = c.arg(0)->as_pointer(); \
                 net_drizzle_c * self = __ptr->extract<net_drizzle_c*>();

XS(xs_new) {
    pl::Ctx c(1);

    net_drizzle_c * dr = new net_drizzle_c;

    if (drizzle_create(&(dr->dr)) == NULL) {
        pl::Carp::croak("drizzle_create:NULL\n");
        return;
    }
    if (drizzle_con_create(&(dr->dr), &(dr->con)) == NULL) {
        pl::Carp::croak("drizzle_con_create:%s\n", drizzle_error(&(dr->dr)));
        return;
    }

    pl::Pointer p((void*)dr, "Net::Drizzle");
    c.ret(&p);
}

XS(xs_host) {
    pl::Ctx c(1);
    DEF_SELF;

    const char * host = drizzle_con_host(&(self->con));
    if (host) {
        pl::Str h(host);
        c.ret(host);
    } else {
        c.return_undef();
    }
}

XS(xs_port) {
    pl::Ctx c(1);
    DEF_SELF;

    int port = drizzle_con_port(&(self->con));
    c.ret(port);
}

XS(xs_set_tcp) {
    pl::Ctx c(3);
    DEF_SELF;

    pl::Str * h = c.arg(1)->as_str();
    pl::Int * p = c.arg(2)->as_int();

    drizzle_con_set_tcp(&(self->con), h->to_c(), p->to_c());
    c.return_true();
}

XS(xs_user) {
    pl::Ctx c(1);
    DEF_SELF;

    const char * user = drizzle_con_user(&(self->con));
    pl::Str h(user);
    c.ret(user);
}

XS(xs_password) {
    pl::Ctx c(1);
    DEF_SELF;

    const char * password = drizzle_con_password(&(self->con));
    pl::Str h(password);
    c.ret(password);
}

XS(xs_set_auth) {
    pl::Ctx c(3);
    DEF_SELF;

    pl::Str * u = c.arg(1)->as_str();
    pl::Str * p = c.arg(2)->as_str();

    drizzle_con_set_auth(&(self->con), u->to_c(), p->to_c());
    c.return_true();
}

XS(xs_set_option_mysql) {
    pl::Ctx c(1);
    DEF_SELF;

    drizzle_con_add_options(&(self->con), DRIZZLE_CON_MYSQL);
    c.return_true();
}

XS(xs_escape) {
    pl::Ctx c(2);
    DEF_SELF;

    pl::Str * src = c.arg(1)->as_str();
    char * buf = new char [src->length()*2+1];
    drizzle_escape_string(buf, src->to_c(), src->length());
    pl::Str dst(buf);
    c.ret(&dst);
}

XS(xs_destroy) {
    pl::Ctx c(1);

    pl::Pointer * p = c.arg(0)->as_pointer();

    net_drizzle_c * d = p->extract<net_drizzle_c*>();
    drizzle_free(&(d->dr));
    delete d;

    c.return_true();
}

extern "C" {
    XS(boot_Net__Drizzle) {
        pl::BootstrapCtx bc;

        pl::Package b("Net::Drizzle", __FILE__);
        b.add_method("new",                   xs_new);

        b.add_method("host",                  xs_host);
        b.add_method("port",                  xs_port);
        b.add_method("set_tcp",               xs_set_tcp);

        b.add_method("user",                  xs_user);
        b.add_method("password",              xs_password);
        b.add_method("set_auth",              xs_set_auth);

        b.add_method("set_option_mysql",      xs_set_option_mysql);

        b.add_method("escape",                xs_escape);

        b.add_method("DESTROY",               xs_destroy);
    }
}

