package Net::Drizzle;
use strict;
use warnings;
use 5.00800;

my $constants = [qw(
DRIZZLE_DEFAULT_TCP_HOST
DRIZZLE_DEFAULT_TCP_PORT
DRIZZLE_DEFAULT_TCP_PORT_MYSQL
DRIZZLE_DEFAULT_UDS
DRIZZLE_DEFAULT_USER
DRIZZLE_MAX_ERROR_SIZE
DRIZZLE_MAX_USER_SIZE
DRIZZLE_MAX_PASSWORD_SIZE
DRIZZLE_MAX_DB_SIZE
DRIZZLE_MAX_INFO_SIZE
DRIZZLE_MAX_SQLSTATE_SIZE
DRIZZLE_MAX_CATALOG_SIZE
DRIZZLE_MAX_TABLE_SIZE
DRIZZLE_MAX_COLUMN_NAME_SIZE
DRIZZLE_MAX_DEFAULT_VALUE_SIZE
DRIZZLE_MAX_PACKET_SIZE
DRIZZLE_MAX_BUFFER_SIZE
DRIZZLE_BUFFER_COPY_THRESHOLD
DRIZZLE_MAX_SERVER_VERSION_SIZE
DRIZZLE_MAX_SCRAMBLE_SIZE
DRIZZLE_STATE_STACK_SIZE
DRIZZLE_ROW_GROW_SIZE
DRIZZLE_DEFAULT_SOCKET_TIMEOUT
DRIZZLE_DEFAULT_SOCKET_SEND_SIZE
DRIZZLE_DEFAULT_SOCKET_RECV_SIZE
DRIZZLE_RETURN_OK
DRIZZLE_RETURN_IO_WAIT
DRIZZLE_RETURN_PAUSE
DRIZZLE_RETURN_ROW_BREAK
DRIZZLE_RETURN_MEMORY
DRIZZLE_RETURN_ERRNO
DRIZZLE_RETURN_INTERNAL_ERROR
DRIZZLE_RETURN_GETADDRINFO
DRIZZLE_RETURN_NOT_READY
DRIZZLE_RETURN_BAD_PACKET_NUMBER
DRIZZLE_RETURN_BAD_HANDSHAKE_PACKET
DRIZZLE_RETURN_BAD_PACKET
DRIZZLE_RETURN_PROTOCOL_NOT_SUPPORTED
DRIZZLE_RETURN_UNEXPECTED_DATA
DRIZZLE_RETURN_NO_SCRAMBLE
DRIZZLE_RETURN_AUTH_FAILED
DRIZZLE_RETURN_NULL_SIZE
DRIZZLE_RETURN_ERROR_CODE
DRIZZLE_RETURN_TOO_MANY_COLUMNS
DRIZZLE_RETURN_ROW_END
DRIZZLE_RETURN_LOST_CONNECTION
DRIZZLE_RETURN_COULD_NOT_CONNECT
DRIZZLE_RETURN_NO_ACTIVE_CONNECTIONS
DRIZZLE_RETURN_HANDSHAKE_FAILED
DRIZZLE_RETURN_MAX
DRIZZLE_RETURN_SERVER_GONE
DRIZZLE_RETURN_SERVER_GONE
DRIZZLE_RETURN_LOST_CONNECTION
DRIZZLE_RETURN_EOF
DRIZZLE_RETURN_LOST_CONNECTION
DRIZZLE_NONE
DRIZZLE_ALLOCATED
DRIZZLE_NON_BLOCKING
DRIZZLE_AUTO_ALLOCATED
DRIZZLE_CON_NONE
DRIZZLE_CON_ALLOCATED
DRIZZLE_CON_MYSQL
DRIZZLE_CON_RAW_PACKET
DRIZZLE_CON_RAW_SCRAMBLE
DRIZZLE_CON_READY
DRIZZLE_CON_NO_RESULT_READ
DRIZZLE_CON_IO_READY
DRIZZLE_CON_STATUS_NONE
DRIZZLE_CON_STATUS_IN_TRANS
DRIZZLE_CON_STATUS_AUTOCOMMIT
DRIZZLE_CON_STATUS_MORE_RESULTS_EXISTS
DRIZZLE_CON_STATUS_QUERY_NO_GOOD_INDEX_USED
DRIZZLE_CON_STATUS_QUERY_NO_INDEX_USED
DRIZZLE_CON_STATUS_CURSOR_EXISTS
DRIZZLE_CON_STATUS_LAST_ROW_SENT
DRIZZLE_CON_STATUS_DB_DROPPED
DRIZZLE_CON_STATUS_NO_BACKSLASH_ESCAPES
DRIZZLE_CON_STATUS_QUERY_WAS_SLOW
DRIZZLE_CAPABILITIES_NONE
DRIZZLE_CAPABILITIES_LONG_PASSWORD
DRIZZLE_CAPABILITIES_FOUND_ROWS
DRIZZLE_CAPABILITIES_LONG_FLAG
DRIZZLE_CAPABILITIES_CONNECT_WITH_DB
DRIZZLE_CAPABILITIES_NO_SCHEMA
DRIZZLE_CAPABILITIES_COMPRESS
DRIZZLE_CAPABILITIES_ODBC
DRIZZLE_CAPABILITIES_LOCAL_FILES
DRIZZLE_CAPABILITIES_IGNORE_SPACE
DRIZZLE_CAPABILITIES_PROTOCOL_41
DRIZZLE_CAPABILITIES_INTERACTIVE
DRIZZLE_CAPABILITIES_SSL
DRIZZLE_CAPABILITIES_IGNORE_SIGPIPE
DRIZZLE_CAPABILITIES_TRANSACTIONS
DRIZZLE_CAPABILITIES_RESERVED
DRIZZLE_CAPABILITIES_SECURE_CONNECTION
DRIZZLE_CAPABILITIES_MULTI_STATEMENTS
DRIZZLE_CAPABILITIES_MULTI_RESULTS
DRIZZLE_CAPABILITIES_SSL_VERIFY_SERVER_CERT
DRIZZLE_CAPABILITIES_REMEMBER_OPTIONS
DRIZZLE_CAPABILITIES_CLIENT
DRIZZLE_CAPABILITIES_LONG_PASSWORD
DRIZZLE_CAPABILITIES_LONG_FLAG
DRIZZLE_CAPABILITIES_CONNECT_WITH_DB
DRIZZLE_CAPABILITIES_TRANSACTIONS
DRIZZLE_CAPABILITIES_PROTOCOL_41
DRIZZLE_CAPABILITIES_SECURE_CONNECTION
DRIZZLE_COMMAND_SLEEP
DRIZZLE_COMMAND_QUIT
DRIZZLE_COMMAND_INIT_DB
DRIZZLE_COMMAND_QUERY
DRIZZLE_COMMAND_FIELD_LIST
DRIZZLE_COMMAND_CREATE_DB
DRIZZLE_COMMAND_DROP_DB
DRIZZLE_COMMAND_REFRESH
DRIZZLE_COMMAND_SHUTDOWN
DRIZZLE_COMMAND_STATISTICS
DRIZZLE_COMMAND_PROCESS_INFO
DRIZZLE_COMMAND_CONNECT
DRIZZLE_COMMAND_PROCESS_KILL
DRIZZLE_COMMAND_DEBUG
DRIZZLE_COMMAND_PING
DRIZZLE_COMMAND_TIME
DRIZZLE_COMMAND_DELAYED_INSERT
DRIZZLE_COMMAND_CHANGE_USER
DRIZZLE_COMMAND_BINLOG_DUMP
DRIZZLE_COMMAND_TABLE_DUMP
DRIZZLE_COMMAND_CONNECT_OUT
DRIZZLE_COMMAND_REGISTER_SLAVE
DRIZZLE_COMMAND_STMT_PREPARE
DRIZZLE_COMMAND_STMT_EXECUTE
DRIZZLE_COMMAND_STMT_SEND_LONG_DATA
DRIZZLE_COMMAND_STMT_CLOSE
DRIZZLE_COMMAND_STMT_RESET
DRIZZLE_COMMAND_SET_OPTION
DRIZZLE_COMMAND_STMT_FETCH
DRIZZLE_COMMAND_DAEMON
DRIZZLE_COMMAND_END
DRIZZLE_COMMAND_DRIZZLE_SLEEP
DRIZZLE_COMMAND_DRIZZLE_QUIT
DRIZZLE_COMMAND_DRIZZLE_INIT_DB
DRIZZLE_COMMAND_DRIZZLE_QUERY
DRIZZLE_COMMAND_DRIZZLE_SHUTDOWN
DRIZZLE_COMMAND_DRIZZLE_CONNECT
DRIZZLE_COMMAND_DRIZZLE_PING
DRIZZLE_COMMAND_DRIZZLE_END
DRIZZLE_REFRESH_GRANT
DRIZZLE_REFRESH_LOG
DRIZZLE_REFRESH_TABLES
DRIZZLE_REFRESH_HOSTS
DRIZZLE_REFRESH_STATUS
DRIZZLE_REFRESH_THREADS
DRIZZLE_REFRESH_SLAVE
DRIZZLE_REFRESH_MASTER
DRIZZLE_SHUTDOWN_DEFAULT
DRIZZLE_SHUTDOWN_WAIT_CONNECTIONS
DRIZZLE_SHUTDOWN_WAIT_TRANSACTIONS
DRIZZLE_SHUTDOWN_WAIT_UPDATES
DRIZZLE_SHUTDOWN_WAIT_ALL_BUFFERS
DRIZZLE_SHUTDOWN_WAIT_CRITICAL_BUFFERS
DRIZZLE_SHUTDOWN_KILL_QUERY
DRIZZLE_SHUTDOWN_KILL_CONNECTION
DRIZZLE_QUERY_ALLOCATED
DRIZZLE_QUERY_STATE_INIT
DRIZZLE_QUERY_STATE_QUERY
DRIZZLE_QUERY_STATE_RESULT
DRIZZLE_QUERY_STATE_DONE
DRIZZLE_RESULT_NONE
DRIZZLE_RESULT_ALLOCATED
DRIZZLE_RESULT_SKIP_COLUMN
DRIZZLE_RESULT_BUFFER_COLUMN
DRIZZLE_RESULT_BUFFER_ROW
DRIZZLE_RESULT_EOF_PACKET
DRIZZLE_RESULT_ROW_BREAK
DRIZZLE_COLUMN_ALLOCATED
DRIZZLE_COLUMN_TYPE_DECIMAL
DRIZZLE_COLUMN_TYPE_TINY
DRIZZLE_COLUMN_TYPE_SHORT
DRIZZLE_COLUMN_TYPE_LONG
DRIZZLE_COLUMN_TYPE_FLOAT
DRIZZLE_COLUMN_TYPE_DOUBLE
DRIZZLE_COLUMN_TYPE_NULL
DRIZZLE_COLUMN_TYPE_TIMESTAMP
DRIZZLE_COLUMN_TYPE_LONGLONG
DRIZZLE_COLUMN_TYPE_INT24
DRIZZLE_COLUMN_TYPE_DATE
DRIZZLE_COLUMN_TYPE_TIME
DRIZZLE_COLUMN_TYPE_DATETIME
DRIZZLE_COLUMN_TYPE_YEAR
DRIZZLE_COLUMN_TYPE_NEWDATE
DRIZZLE_COLUMN_TYPE_VARCHAR
DRIZZLE_COLUMN_TYPE_BIT
DRIZZLE_COLUMN_TYPE_VIRTUAL
DRIZZLE_COLUMN_TYPE_NEWDECIMAL
DRIZZLE_COLUMN_TYPE_ENUM
DRIZZLE_COLUMN_TYPE_SET
DRIZZLE_COLUMN_TYPE_TINY_BLOB
DRIZZLE_COLUMN_TYPE_MEDIUM_BLOB
DRIZZLE_COLUMN_TYPE_LONG_BLOB
DRIZZLE_COLUMN_TYPE_BLOB
DRIZZLE_COLUMN_TYPE_VAR_STRING
DRIZZLE_COLUMN_TYPE_STRING
DRIZZLE_COLUMN_TYPE_GEOMETRY
DRIZZLE_COLUMN_TYPE_DRIZZLE_TINY
DRIZZLE_COLUMN_TYPE_DRIZZLE_LONG
DRIZZLE_COLUMN_TYPE_DRIZZLE_DOUBLE
DRIZZLE_COLUMN_TYPE_DRIZZLE_NULL
DRIZZLE_COLUMN_TYPE_DRIZZLE_TIMESTAMP
DRIZZLE_COLUMN_TYPE_DRIZZLE_LONGLONG
DRIZZLE_COLUMN_TYPE_DRIZZLE_DATETIME
DRIZZLE_COLUMN_TYPE_DRIZZLE_DATE
DRIZZLE_COLUMN_TYPE_DRIZZLE_VARCHAR
DRIZZLE_COLUMN_TYPE_DRIZZLE_VIRTUAL
DRIZZLE_COLUMN_TYPE_DRIZZLE_NEWDECIMAL
DRIZZLE_COLUMN_TYPE_DRIZZLE_ENUM
DRIZZLE_COLUMN_TYPE_DRIZZLE_BLOB
DRIZZLE_COLUMN_TYPE_DRIZZLE_MAX
DRIZZLE_COLUMN_TYPE_DRIZZLE_BLOB
DRIZZLE_COLUMN_FLAGS_NONE
DRIZZLE_COLUMN_FLAGS_NOT_NULL
DRIZZLE_COLUMN_FLAGS_PRI_KEY
DRIZZLE_COLUMN_FLAGS_UNIQUE_KEY
DRIZZLE_COLUMN_FLAGS_MULTIPLE_KEY
DRIZZLE_COLUMN_FLAGS_BLOB
DRIZZLE_COLUMN_FLAGS_UNSIGNED
DRIZZLE_COLUMN_FLAGS_ZEROFILL
DRIZZLE_COLUMN_FLAGS_BINARY
DRIZZLE_COLUMN_FLAGS_ENUM
DRIZZLE_COLUMN_FLAGS_AUTO_INCREMENT
DRIZZLE_COLUMN_FLAGS_TIMESTAMP
DRIZZLE_COLUMN_FLAGS_SET
DRIZZLE_COLUMN_FLAGS_NO_DEFAULT_VALUE
DRIZZLE_COLUMN_FLAGS_ON_UPDATE_NOW
DRIZZLE_COLUMN_FLAGS_PART_KEY
DRIZZLE_COLUMN_FLAGS_NUM
DRIZZLE_COLUMN_FLAGS_GROUP
DRIZZLE_COLUMN_FLAGS_UNIQUE
DRIZZLE_COLUMN_FLAGS_BINCMP
DRIZZLE_COLUMN_FLAGS_GET_FIXED_FIELDS
DRIZZLE_COLUMN_FLAGS_IN_PART_FUNC
DRIZZLE_COLUMN_FLAGS_IN_ADD_INDEX
DRIZZLE_COLUMN_FLAGS_RENAMED
)];

our %EXPORT_TAGS = (
    'constants' => $constants
);
our @EXPORT_OK = @$constants;

our @ISA;
BEGIN {
    our $VERSION = '0.01';

    eval {
        require XSLoader;
        XSLoader::load(__PACKAGE__, $VERSION);
        1;
    } or do {
        require DynaLoader;
        push @ISA, 'DynaLoader';
        __PACKAGE__->bootstrap($VERSION);
    };
    use Exporter 'import';
};
use Net::Drizzle::Result;
use Net::Drizzle::Connection;

1;
__END__

=head1 NAME

Net::Drizzle - perl bindings for libdrizzle

=head1 SYNOPSIS

    use Net::Drizzle;

    my $dr = Net::Drizzle->new();
    my $con = $dr->con_create();
    $con->set_tcp('localhost', 10010);
    $con->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL);
    $con->set_db("information_schema");

    $dr->escape(q{"});

    my $s1 = $con->query_add('select * from foo;');

    $dr->query_run_all();

    if ($s1->error_code != 0) {
        die "@{[ $s1->error_code ]}: @{[ $s1->error ]}";
    }

    while (my $row = $s1->row_next) {
        my @row = @$row;
        printf "$i: $row[0], $row[1]";
    }

=head1 DESCRIPTION

Net::Drizzle is perl bindings for libdrizzle.
Net::Drizzle has a straightforward interface for libdrizzle.
If you want a DBI like interface, please use DBD::Drizzle instead.

libdrizzle can connect to mysql server and drizzle server.
You can use libdrizzle as better version of libmysqlclient.

libdrizzle's great features are listed below.

=over 4

=item Concurrent Queries

Net::Drizzle can handle the concurrent queries.The example code is in the synopsis.

=item Non-blocking I/O support

Net::Drizzle can use with any event driven frameworks such as POE, Danga::Socket, etc.

=item Server interface

This library provides server protocol interface.
You can use it to write proxies or "fake" drizzle and mysql servers.

=back

=head1 METHODS

=over 4

=item my $drizzle = Net::Drizzle->new();

create new instance of Net::Drizzle.

=item my $con = $drizzle->con_create();

create new connection object.

=item my $con = $drizzle->con_add_tcp($host, $port, $user, $password, $db, $options);

create new connection object for a lot of informations.

=item $drizzle->query_run_all();

run all queries concurrently.

=item Net::Drizzle->escape(q{"';})

quote meta chars.

=item Net::Drizzle->hex_string("\x61");

This method is same as unpack('H*', $str).

=item my $ver = Net::Drizzle->drizzle_version();

get the version of libdrizzle

=item $drizzle->add_options($options)

add options.

=item $drizzle->con_wait();

Wait for I/O on connections.

=item $drizzle->error();

Return an error string for last library error encountered.

=item $drizzle->error_code()

Return an error code for last library error encountered.

=item $drizzle->query_run()

Run queries concurrently, returning when one is complete.

=back

=head1 BENCHMARKS

This is a simple benchmark result of Net::Drizzle(by benchmark/simple.pl).

            Net::Drizzle: 0.01
            DBD::mysql:   4.007
            DBI: 1.608

                          Rate  dbd_mysql     serial concurrent
             dbd_mysql  65.6/s         --       -48%       -53%
             serial      126/s        92%         --       -11%
             concurrent  141/s       115%        12%         --

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom @*(#RJKLFHFSDLJF gmail.comE<gt>

=head1 THANKS TO

kazuhooku(many advice and suggested to write this module)

=head1 SEE ALSO

L<DBD::Drizzle>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
