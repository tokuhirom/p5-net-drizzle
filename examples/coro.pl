use strict;
use warnings;
use Net::Drizzle ':constants';
use IO::Poll qw/POLLIN POLLOUT/;
use Coro;
use Coro::Handle;

&main;exit;

sub main {
    my @coros;
    for my $i (0..10) {
        push @coros, async { one_request($i) };
    }
    $_->join for @coros;
}

sub one_request {
    my $i = shift;

    my $drizzle = Net::Drizzle->new()
                              ->add_options(DRIZZLE_NON_BLOCKING);

    my $con = $drizzle->con_create()
                      ->add_options(DRIZZLE_CON_MYSQL)
                      ->set_charset(8)
                      ->set_db('test_net_drizzle_crowler');

    my $sql = 'SELECT COUNT(*) FROM entry';
    $con->query_add($sql);
    $drizzle->query_run; # connect to server
    my $fh = Coro::Handle->new_from_fh($con->fh);
    my $query;
    while (not defined $query) {
        $query = $drizzle->query_run;
        if ($con->events & POLLIN) {
            $fh->readable;
            $con->set_revents( POLLIN );
        }
        if ($con->events & POLLOUT) {
            $fh->writable;
            $con->set_revents( POLLOUT );
        }
    }
    my $count = $query->result->row_next->[0];
    print "count: $count($i)\n";
};

