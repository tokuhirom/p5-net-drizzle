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

get the error code for result.

=item my $err = $result->error();

get the error message for result.

=item my $info = $result->info();

get the info message.

=item my $insert_id = $result->insert_id();

get the insert_id.

=item my $warning_count = $result->warning_count();

get the warning_count.

=item my $column_count = $result->column_count();

get the number of columns.

=item my $row_count = $result->row_count();

get the number of rows.

=item my $column = $result->column_next();

Get next buffered column from a result structure.

=item $result->buffer();

Buffer all data for a result.

=item $result->row_next();

Get next buffered row from a fully buffered result.

=item $result->fetchrow_arrayref();

alias of row_next() for DBI users

=item my $col = $result->column_read();

Read column information.

=item my $column = $result->column_create();

Create a instance of Net::Drizzle::Column.

=item my $row_number = $result->row_read;

Get next row number for unbuffered results. Use the $result->field* functions
to read individual fields after this function succeeds.

=item my ($ret, $field) = $res->field_buffer();

Buffer one field.

=back

=head1 METHODS for servers

=over 4

=item $result->set_eof();

Set EOF for a result.

=item $result->write($flush);

Write result packet.

=item $result->set_column_count($n);

Set the number of fields in a result set.

=item $result->calc_row_size();

Set result row packet size from field and size arrays.

=item $result->fields_write(...);

Send a fields over a connection

=item $result->row_write();

Write next row.

=back

=head1 AUTHOR

Tokuhiro Matsuno

=cut
