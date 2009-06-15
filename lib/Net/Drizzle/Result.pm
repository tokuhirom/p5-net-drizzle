package Net::Drizzle::Result;
use strict;
use warnings;

# alias for dbi users
sub fetchrow_arrayref { shift->row_next(@_) }

1;
__END__

=pod

=head1 NAME

Net::Drizzle::Result - result object for Net::Drizzle

=head1 METHODS

=over 4

=item my $err = $result->error_code();

get the error code.

=item my $err = $result->error();

get the error message.

=item my $info = $result->info();

get the info message.

=item my $column_count = $result->column_count();

get the number of columns.

=item $result->buffer();

Buffer all data for a result.

=item $result->row_next();

Get next buffered row from a fully buffered result.

=item $result->selectrow_arrayref();

alias of row_next()

=back

=head1 AUTHOR

Tokuhiro Matsuno

=cut
