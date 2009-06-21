package Net::Drizzle::Connection;
use strict;
use warnings;
use IO::Handle;

sub fh {
    my $self = shift;
    my $fh = IO::Handle->new;
       $fh->fdopen($self->fd, 'r+');
       $fh;
}

1;

__END__

=pod

=head1 NAME

Net::Drizzle::Connection - connection object for Net::Drizzle

=head1 METHODS

=over 4

=item my $con = Net::Drizzle::Connection->new();

create new instance.

=item my ($ret, $result) = $con->query('select * from foo');

Send query to server.

=item $con->drizzle()

Get the instance of Net::Drizzle that the connection belongs to.

=item $con->connect()

Connect to server.

=item $con->set_revents($revents);

Set events that are ready for a connection. This is used with the external
event callbacks.

=item $con->set_db($dbname);

set the db name.

=item $con->protocol_version($protocol);

Get protocol version for a connection.

=item $con->set_protocol_version($protocol);

Set protocol version for a connection.

=item $con->set_data($data);

Set application data for a connection.

=item $con->data($data);

Get application data for a connection.

=item $con->set_scramble($scramble);

Set scramble buffer for a connection.

=item $con->set_status($status);

Set status for a connection.

=item $con->set_capabilities($capabilities);

Set capabilities for a connection.

=item $con->set_charset($charset);

Set charset for a connection.

=item $con->set_thread_id($thread_id);

Set thread_id for a connection.

=item $con->set_max_packet_size($max_packet_size);

Set max_packet_size for a connection.


=item my $host = $con->host();

Get the server hostname

=item my $user = $con->user();

get the user name

=item my $password = $con->password();

get the password

=item my $port = $con->port();

get the port

=item $con->set_tcp($host, $port);

set up the tcp thing.

=item $con->set_auth($user, $password);

set up authentication thing

=item $con->add_options($opt);

Add options for a connection.

=item $con->options($opt);

Get options for a connection.

=item my $new_con = $con->clone();

clone the connection.


=item my $sth = $con->query_add('select * from foo');

add the query for concurrent request.

=item my $sth = $con->query_str('select * from foo');

create new query

=item $con->set_fd($fd)

Use given file descriptor for connction.

=item $con->result_create($fd)

Initialize a result structure.

=item $con->command_buffer()

Read command and buffer it.

=item my $fd = $con->fd()

Get file descriptor for connection.

=item my $fh = $con->fh()

Get file handle for connection.

=back

=head2 SERVER METHODS

=over 4

=item $con->server_handshake_write();

Write server handshake packet.

=item $con->client_handshake_read();

Read client handshake packet.

=item $con->set_server_version($ver);

Set server version for connection.

=back

=head1 AUTHOR

Tokuhiro Matsuno

=cut
