#include "net_drizzle.h"

=head1 NAME

Net::Drizzle::Connection - Connection object for Net::Drizzle

=head1 METHODS

=over 4

=cut

MODULE = Net::Drizzle::Connection  PACKAGE = Net::Drizzle::Connection

PROTOTYPES: DISABLE

VERSIONCHECK: DISABLE

=item my $con = Net::Drizzle::Connection->new();

Create new instance of Net::Drizzle::Connection.

=cut
SV*
Net::Drizzle::Connection::new()
CODE:
    PERL_UNUSED_VAR(CLASS);

    drizzle_con_st * con;
    SV * drizzle = _create_drizzle();
    if ((con = drizzle_con_create(GET_DRIZZLE(drizzle), NULL)) == NULL) {
        Perl_croak(aTHX_ "drizzle_con_create:NULL\n");
    }

    RETVAL = _create_con(drizzle, con);
OUTPUT:
    RETVAL

=item my ($ret, $result) = $con->query('select * from foo');

Send query to server.

=cut
void
query(SV*self, SV*query_sv)
PPCODE:
    dTARGET;
    net_con * con = XS_STATE(net_con*, self);
    STRLEN query_len;
    const char * query_c = SvPV_const(query_sv, query_len);
    drizzle_return_t ret;
    drizzle_result_st *result = drizzle_query(con->con, NULL, query_c, query_len, &ret);

    XPUSHi(ret);
    mXPUSHs(_create_result(self, NULL, result));
    XSRETURN(2);

=item $con->drizzle()

Get the instance of Net::Drizzle that the connection belongs to.
=cut
SV*
drizzle(net_con* self)
CODE:
    RETVAL = SvREFCNT_inc(self->drizzle);
OUTPUT:
    RETVAL

=item $con->close();

Close server connection.
=cut
void
close(net_con* self)
CODE:
    drizzle_con_close(self->con);

=item $con->connect()

Connect to server.
=cut
int
connect(net_con* con)
CODE:
    drizzle_return_t ret = drizzle_con_connect(con->con);
    if (ret != DRIZZLE_RETURN_OK) {
        drizzle_st *drizzle = drizzle_con_drizzle(con->con);
        Perl_croak(aTHX_ "drizzle_con_connect:%s\n", drizzle_error(drizzle));
    }
    RETVAL = ret;
OUTPUT:
    RETVAL

=item $con->set_revents($revents);

Set events that are ready for a connection. This is used with the external
event callbacks.

=cut
SV*
set_revents(SV* self, short revents)
CODE:
    net_con * con = XS_STATE(net_con*, self);

    if (revents != 0) {
        con->con->options|= DRIZZLE_CON_IO_READY;
    }

    con->con->revents= revents;
    con->con->events&= (short)~revents;
    /* XXX don't work this : drizzle_con_set_revents(con->con, revents); */
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item my $events = $con->events();

Get events for connection.

=cut
short
events(SV* self)
CODE:
    net_con * con = XS_STATE(net_con*, self);

    RETVAL = con->con->events;
OUTPUT:
    RETVAL

=item $con->set_db($dbname);

set the db name.

=cut
SV*
set_db(SV* self, const char *db)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_db(con->con, db);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->set_data($data);

Set application data for a connection.
=cut
SV*
set_data(SV* self, SV *db)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_data(con->con, SvREFCNT_inc(newSVsv(db)));
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->data($data);

Get application data for a connection.
=cut
SV*
data(SV* self)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    SV *data = drizzle_con_data(con->con);
    RETVAL = SvREFCNT_inc(data);
OUTPUT:
    RETVAL

=item $con->protocol_version($protocol);

Get protocol version for a connection.

=cut
U8
protocol_version(SV* self)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    RETVAL = drizzle_con_protocol_version(con->con);
OUTPUT:
    RETVAL

=item $con->set_protocol_version($protocol);

Set protocol version for a connection.

=cut
SV*
set_protocol_version(SV* self, U8 protocol_version)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_protocol_version(con->con, protocol_version);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->set_scramble($scramble);

Set scramble buffer for a connection.

=cut
SV*
set_scramble(SV* self, unsigned char* scramble)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_scramble(con->con, scramble);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->set_status($status);

Set status for a connection.

=cut
SV*
set_status(SV* self, int status)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_status(con->con, status);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->set_capabilities($capabilities);

Set capabilities for a connection.

=cut
SV*
set_capabilities(SV* self, int capabilities)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_capabilities(con->con, capabilities);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->set_charset($charset);

Set charset for a connection.

=cut
SV*
set_charset(SV* self, U8 charset)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_charset(con->con, charset);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->set_thread_id($thread_id);

Set thread_id for a connection.

=cut
SV*
set_thread_id(SV* self, U32 protocol_version)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_thread_id(con->con, protocol_version);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->set_max_packet_size($max_packet_size);

Set max_packet_size for a connection.

=cut
SV*
set_max_packet_size(SV* self, U32 protocol_version)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_max_packet_size(con->con, protocol_version);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL


=item $con->set_fd($fd)

Use given file descriptor for connection.

=cut
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

=item $con->result_create($fd)

Initialize a result structure.

=cut
SV*
result_create(SV *_self)
CODE:
    net_con * con = XS_STATE(net_con*, _self);
    drizzle_result_st *result = drizzle_result_create(con->con, NULL);
    if (result == NULL) {
        drizzle_st *drizzle = drizzle_con_drizzle(con->con);
        Perl_croak(aTHX_ "drizzle_result_create:%s\n", drizzle_error(drizzle));
    }
    RETVAL = _create_result(_self, NULL, result);
OUTPUT:
    RETVAL

=item $con->command_buffer()

Read command and buffer it.

=cut
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

=item my $fd = $con->fd()

Get file descriptor for connection.

=cut
int
fd(net_con * con)
CODE:
    int fd = drizzle_con_fd(con->con);
    RETVAL = fd;
OUTPUT:
    RETVAL

=item my $host = $con->host();

Get the server host

=cut
const char *
host(net_con* self)
CODE:
    RETVAL = drizzle_con_host(self->con);
OUTPUT:
    RETVAL

=item my $user = $con->user();

Get the server user

=cut
const char *
user(net_con* self)
CODE:
    RETVAL = drizzle_con_user(self->con);
OUTPUT:
    RETVAL

=item my $password = $con->password();

Get the server password

=cut
const char *
password(net_con* self)
CODE:
    RETVAL = drizzle_con_password(self->con);
OUTPUT:
    RETVAL

=item my $port = $con->port();

Get the server port

=cut
U16
port(net_con* self)
CODE:
    RETVAL = drizzle_con_port(self->con);
OUTPUT:
    RETVAL


=item $con->set_tcp($host, $port);

set up the tcp thing.

=cut
SV *
set_tcp(SV* self, const char *host, U16 port)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_tcp(con->con, host, port);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->set_auth($user, $password);

set up authentication thing

=cut
SV*
set_auth(SV* self, const char *user, const char* password)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_auth(con->con, user, password);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item $con->options($opt);

Get options for a connection.

=cut
int
options(net_con* con)
CODE:
    drizzle_options_t opt = drizzle_con_options(con->con);
    RETVAL = opt;
OUTPUT:
    RETVAL


=item $con->add_options($opt);

Add options for a connection.
=cut
SV*
add_options(SV* self, int opt)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_add_options(con->con, opt);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL

=item my $new_con = $con->clone();

clone the connection.

=cut
SV*
clone(net_con* self)
CODE:
    drizzle_con_st *newcon;
    if ((newcon = drizzle_con_clone(GET_DRIZZLE(self->drizzle), NULL, self->con)) == NULL) {
        Perl_croak(aTHX_ "drizzle_con_clone:%s\n", drizzle_error(GET_DRIZZLE(self->drizzle)));
    }
    RETVAL = _create_con(self->drizzle, newcon);
OUTPUT:
    RETVAL

=item my $sth = $con->query_add('select * from foo');

add the query for concurrent request.

=cut
SV*
query_add(SV *_self, SV *query)
CODE:
    net_con * self = XS_STATE(net_con*, _self);
    drizzle_st * drizzle = GET_DRIZZLE(self->drizzle);
    size_t query_len;
    const char* orig_query_c = SvPV(query, query_len);
    SV * copied_query = newSVpvn(orig_query_c, query_len);
    const char * copied_query_c = SvPV_nolen(copied_query);
    drizzle_query_st *query_d;
    av_push(GET_DRIZZLE_QUERIES(self->drizzle), SvREFCNT_inc(copied_query)); /* note. we should not free the query_c. because drizzle_query_add does not make a copy. use this directly. */
    if ((query_d = drizzle_query_add(drizzle, NULL, self->con, NULL, copied_query_c,
                              query_len, (drizzle_query_options_t)0, NULL)) == NULL) {
         Perl_croak(aTHX_ "drizzle_query_add:%s\n", drizzle_error(drizzle));
    }
    RETVAL = _create_query(self->drizzle, _self, query_d);
OUTPUT:
    RETVAL

=item my $sth = $con->query_str('select * from foo');

create new query
=cut
SV*
query_str(SV *_self, const char*query)
CODE:
    net_con * self = XS_STATE(net_con*, _self);
    LOG("CREATE result 0x%X\n", (unsigned int)self->drizzle);

    drizzle_return_t ret;
    drizzle_result_st *result = drizzle_query_str(self->con, NULL, query, &ret);
    if (ret != DRIZZLE_RETURN_OK) {
        drizzle_st * drizzle = XS_STATE(drizzle_st*, self->drizzle);
        Perl_croak(aTHX_ "drizzle_query_str:%s\n", drizzle_error(drizzle));
    }
    RETVAL= _create_result(_self, NULL, result);
OUTPUT:
    RETVAL

=item my $fh = $con->fh()

Get file handle for connection.

=back

=head2 SERVER METHODS

=over 4

=item $con->server_handshake_write();

Write server handshake packet.

=back

=cut

void
server_handshake_write(SV* self)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_return_t ret = drizzle_server_handshake_write(con->con);
    if (ret != DRIZZLE_RETURN_OK) {
        drizzle_st *drizzle = drizzle_con_drizzle(con->con);
        Perl_croak(aTHX_ "drizzle_server_handshake_write:%s\n", drizzle_error(drizzle));
    }

=item $con->client_handshake_read();

Read client handshake packet.

=cut
int
client_handshake_read(SV*self)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_return_t ret = drizzle_client_handshake_read(con->con);
    if (ret != DRIZZLE_RETURN_OK && ret != DRIZZLE_RETURN_LOST_CONNECTION) {
        drizzle_st *drizzle = drizzle_con_drizzle(con->con);
        Perl_croak(aTHX_ "drizzle_client_handshake_read:%s\n", drizzle_error(drizzle));
    }
    RETVAL = ret;
OUTPUT:
    RETVAL

=item $con->set_server_version($ver);

Set server version for connection.

=cut
SV*
set_server_version(SV* self, const char* server_version)
CODE:
    net_con * con = XS_STATE(net_con*, self);
    drizzle_con_set_server_version(con->con, server_version);
    RETVAL = SvREFCNT_inc(self);
OUTPUT:
    RETVAL


void
DESTROY(SV *_self)
CODE:
    net_con * self = XS_STATE(net_con*, _self);
    LOG("DESTROY connection 0x%X, drizzle->refcnt=%d\n", (unsigned int)self->drizzle, (int)SvREFCNT(self->drizzle));

    if (self->drizzle != NULL) {
         SvREFCNT_dec(self->drizzle);
    } else {
        LOG("FREE connection\n");
        drizzle_con_free(self->con);
    }
    Safefree(self);

=back

=head1 AUTHOR

Tokuhiro Matsuno

=cut
