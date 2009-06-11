package Net::Drizzle;
use strict;
use warnings;
our $VERSION = '0.01';
use 5.00800;

our @ISA;

eval {
    require XSLoader;
    XSLoader::load(__PACKAGE__, $VERSION);
    1;
} or do {
    require DynaLoader;
    push @ISA, 'DynaLoader';
    __PACKAGE__->bootstrap($VERSION);
};

1;
__END__

=head1 NAME

Net::Drizzle -

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

    while (my @row = $s1->row_next) {
        printf "$i: $row[0], $row[1]";
    }

=head1 DESCRIPTION

Net::Drizzle is perl bindings for libdrizzle.

=head1 METHODS

=over 4

=item my $drizzle = Net::Drizzle->new();

create new instance of Net::Drizzle.

=item my $con = $drizzle->create_con();

create new connection object.

=item $drizzle->query_run_all();

run all queries concurrently.

=item Net::Drizzle->escape(q{"';})

quote meta chars.

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

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
