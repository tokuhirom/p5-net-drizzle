use strict;
use warnings;
use Net::Drizzle ':constants';
use IO::Socket::INET;
use Test::TCP;

my $ROWS = 10;
sub true  () { 1 }
sub false () { 0 }
my $DRIZZLE_FIELD_MAX = 32;
$SIG{PIPE} = sub { die "SIGPIPE" };

test_tcp(
    client => sub {
        my $port = shift;
        wait_port($port);
        warn $port;
        my $con = Net::Drizzle::Connection->new()
                                          ->set_tcp('127.0.0.1', $port)
                                          ->add_options(DRIZZLE_CON_MYSQL)
                                          ->set_db("information_schema");
        warn "SEND QUERY";
        warn $con->fd;
        my $sth = $con->query_str("SELECT table_schema,table_name FROM tables");
        warn "BUFFERING";
        $sth->buffer();
        warn $sth->error();
    },
    server => sub {
        my $port = shift;
        $SIG{PIPE} = sub { die "SIGPIPE" };
        warn $port;
        my $sock = IO::Socket::INET->new(
            LocalAddr => 'localhost',
            LocalPort => $port,
            Proto     => 'tcp',
            ReuseAddr => 1,
            Listen    => 32,
        ) or die $!;
        my $drizzle = Net::Drizzle->new();
        while (1) {
            my $csock = $sock->accept or die "cannot accept";
            warn "ACCEPT ", $csock->fileno;
            my $con = $drizzle->con_create()
                              ->set_fd( $csock->fileno )
                              ->add_options(DRIZZLE_CON_MYSQL);
            _handle($con);
        }
    },
);

sub _handle {
    my $con = shift;

    # Handshake packets.

    $con->set_protocol_version(10)
        ->set_server_version("Net::Drizzle example 1.2.3")
        ->set_thread_id(1)
        ->set_scramble("ABCDEFGHIJKLMNOPQRST")
        ->set_capabilities(DRIZZLE_CAPABILITIES_NONE)
        ->set_charset(8)
        ->set_status(DRIZZLE_CON_STATUS_NONE)
        ->set_max_packet_size(DRIZZLE_MAX_PACKET_SIZE);

    $con->server_handshake_write();
    $con->client_handshake_read();
    
    my $res = $con->result_create();
    $con->result_write($res, true);

    while (1) {
        my ($data, $command, $total, $ret) = $con->command_buffer();
        if ($ret == DRIZZLE_RETURN_LOST_CONNECTION ||
                ($ret == DRIZZLE_RETURN_OK && $command == DRIZZLE_COMMAND_QUIT)) {
                return;
        }
        printf("%u %s\n", $command, defined($data) ? $data : '(undef)');

        my $res = $con->result_create();
        if ($command != DRIZZLE_COMMAND_QUERY) {
            $con->result_write($res, true);
            next;
        }
        $res->set_column_count(2);
        $con->result_write($res, false);

        my $column = $con->column_create()
                         ->set_catalog("default")
                         ->set_db("drizzle_test_db")
                         ->set_table("drizzle_set_table")
                         ->set_orig_table("drizzle_test_table")
                         ->set_name("test_column_1")
                         ->set_orig_name("test_column_1")
                         ->set_charset(8)
                         ->set_size($DRIZZLE_FIELD_MAX)
                         ->set_type(DRIZZLE_COLUMN_TYPE_VARCHAR);
        $res->column_write($column);
        $res->set_eof(1);
        $con->result_write($res, false);

        for my $x (0..$ROWS) {
            my @field = ("field $x-1", "field $x-2");
            $res->calc_row_size(@field);
            $res->row_write();
            $res->field_write($_) for @field;
        }
        $con->result_write($res, true);
    }
}

