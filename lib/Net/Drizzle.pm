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
    $dr->query_add($c1, 'select * from foo;');

    my @results = $dr->run_all();

    my $i = 0;
    for my $res (@results) {
        if ($res->error_code != 0) {
            die "@{[ $res->error_code ]}: @{[ $res->error ]}";
        }

        while (my $row = $res->next) {
            printf "$i: $row[0], $row[1]";
        }

        $i++;
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
