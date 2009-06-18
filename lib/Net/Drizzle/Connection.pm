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

=item $con->set_db($dbname);

set the db name.

=item my $host = $con->host();

get the server hostname

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

set the option value

=item my $new_con = $con->clone();

clone the connection.

=item my $sth = $con->query_add('select * from foo');

add the query for concurrent request.

=item my $sth = $con->query_str('select * from foo');

create new query

=back

=head1 AUTHOR

Tokuhiro Matsuno

=cut