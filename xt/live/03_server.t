use strict;
use warnings;
use Net::Drizzle ':constants';
use IO::Socket::INET;
use Test::TCP;
use Test::More tests => 2;

sub true  () { 1 }
sub false () { 0 }
my $rows = [['a', 'b'], ['c', 'd']];

test_tcp(
    client => sub {
        my $port = shift;

        my $con = Net::Drizzle::Connection->new()
                                          ->set_tcp('127.0.0.1', $port)
                                          ->add_options(DRIZZLE_CON_MYSQL)
                                          ->set_db("information_schema");
        my $sth = $con->query_str("SELECT table_schema,table_name FROM tables");
        $sth->buffer();
        is($sth->error_code, 0);
        my @got;
        while (my $row = $sth->row_next) {
            push @got, $row;
        }
        is_deeply(\@got, $rows);
    },
    server => sub {
        my $port = shift;
        _server($port);
    },
);

sub _server {
    my $port = shift;
    $SIG{PIPE} = "IGNORE";
    my $sock = IO::Socket::INET->new(
        LocalAddr => "0.0.0.0:$port",
        Proto     => 'tcp',
        ReuseAddr => 1,
        Listen    => 10,
    );
    die $! unless $sock;
    my $drizzle = Net::Drizzle->new();
    while (1) {
        my $csock = $sock->accept or die "cannot accept";
        eval {
            my $con = $drizzle->con_create()
                            ->set_fd($csock->fileno)
                            ->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL);
            _handle($con);
        };
        warn $@ if $@;
    }
}

sub _handle {
    my $con = shift;

    # Handshake packets.
    $con->set_protocol_version(10)
        ->set_server_version("Net::Drizzle example 1.2.3")
        ->set_thread_id(1)
        ->set_scramble("ABCDEFGHIJKLMNOPQRST")
        ->set_capabilities(Net::Drizzle::DRIZZLE_CAPABILITIES_NONE)
        ->set_charset(8)
        ->set_status(DRIZZLE_CON_STATUS_NONE)
        ->set_max_packet_size(DRIZZLE_MAX_PACKET_SIZE);

    $con->server_handshake_write();
    $con->client_handshake_read();

    $con->result_create()
        ->write(true);

    while (1) {
        my ($data, $command, $total, $ret) = $con->command_buffer();
        if ($ret == DRIZZLE_RETURN_LOST_CONNECTION) {
            warn "LOST CONNECTION, $ret";
            return;
        }
        if ($ret == DRIZZLE_RETURN_OK && $command == DRIZZLE_COMMAND_QUIT) {
            warn "USER QUIT";
            return;
        }
        #use Data::Dumper; warn Dumper([$data, $command, $total, $ret]);
        printf("got query %u '%s'\n", $command, defined($data) ? $data : '(undef)');

        my $res = $con->result_create();
        if ($command != DRIZZLE_COMMAND_QUERY) {
            $res->write(true);
            warn "not a query, skipped, $command";
            next;
        }


        $res->set_column_count(2)
            ->write(false);

        $res->column_create()
            ->set_catalog("default")
            ->set_db("drizzle_test_db")
            ->set_table("drizzle_set_table")
            ->set_orig_table("drizzle_test_table")
            ->set_name("test_column_1")
            ->set_orig_name("test_column_1")
            ->set_charset(8)
            ->set_size(scalar(@$rows))
            ->set_type(DRIZZLE_COLUMN_TYPE_VARCHAR)
            ->write()
            ->set_name("test_column_2")
            ->set_orig_name("test_column_2")
            ->write();

        $res->set_eof(true)
            ->write(false);

        for my $fields (@$rows) {
            $res->calc_row_size(@$fields) # This is needed for MySQL and old Drizzle protocol.
                ->row_write();
            $res->fields_write(@$fields);
        }
        $res->write(true);
    }
}

