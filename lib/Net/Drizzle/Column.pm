package Net::Drizzle::Column;
use strict;
use warnings;

# nop

1;

__END__

=pod

=head1 NAME

Net::Drizzle::Column - Column object for Net::Drizzle

=head1 METHODS

=over 4

=item catalog

    my $catalog = $column->catalog;

Get catalog for a column.

     

=item set_catalog

    my $catalog = $column->catalog;

Set catalog for a column.

     

=item db

    my $db = $column->db;

Get db for a column.

     

=item set_db

    my $db = $column->db;

Set db for a column.

     

=item table

    my $table = $column->table;

Get table for a column.

     

=item set_table

    my $table = $column->table;

Set table for a column.

     

=item orig_table

    my $orig_table = $column->orig_table;

Get orig_table for a column.

     

=item set_orig_table

    my $orig_table = $column->orig_table;

Set orig_table for a column.

     

=item name

    my $name = $column->name;

Get name for a column.

     

=item set_name

    my $name = $column->name;

Set name for a column.

     

=item orig_name

    my $orig_name = $column->orig_name;

Get orig_name for a column.

     

=item set_orig_name

    my $orig_name = $column->orig_name;

Set orig_name for a column.

     

=item set_charset

Set charset for column.
     

=item set_size

Set size for column.
     

=item set_type

Set type for column.
     

=item write

Write column information.
     

=item DESTROY

Destructor.
     


=back

=head1 SEE ALSO

L<Net::Drizzle>

=cut

