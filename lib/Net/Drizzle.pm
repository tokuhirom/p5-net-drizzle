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
    $dr->set_tcp('localhost', 10010);            # optional
    $dr->set_auth('dankogai', 'kogaidan'); # optional
    $dr->set_option_mysql();

    $dr->escape(q{"});

    my $c1 = $dr->con_clone();
    my $s1 = $c1->query_add('select * from foo;');

    $dr->query_run_all();

    if ($s1->error_code != 0) {
        die "@{[ $s1->error_code ]}: @{[ $s1->error ]}";
    }

    while (my @row = $s1->next) {
        printf "$i: $row[0], $row[1]";
    }

=head1 DESCRIPTION

Net::Drizzle is

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom @*(#RJKLFHFSDLJF gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
