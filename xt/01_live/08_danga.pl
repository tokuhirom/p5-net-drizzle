use strict;
use warnings;
use Net::Drizzle ':constants';
use Test::More;

plan tests => 1;

my $drizzle = Net::Drizzle->new()
                          ->add_options(DRIZZLE_NON_BLOCKING);
my $con = $drizzle->con_create()
                  ->add_options(DRIZZLE_CON_MYSQL)
                  ->set_db('test_net_drizzle_crowler');
my $nc;
my $sql;
enqueue(
    sub {
        my $sql = 'SELECT COUNT(*) FROM echo;';
        $nc  = $con->clone;
        $nc->query_add($sql);
        enqueue( \&bar );
    }
);

my @queue;
sub mainloop {
    while (1) {
        my $code = shift @queue;
        $code->();
    }
}
sub enqueue {
    push @queue, $_[0];
}

sub bar {
    while (1) {
        my ($ret, $query) = $drizzle->query_run;
        warn $ret if $ret;
        if ($ret != DRIZZLE_RETURN_IO_WAIT && $ret != DRIZZLE_RETURN_OK) {
            ::fail "query error: " . $drizzle->error(). '('.$drizzle->error_code .')';
        }
        if ($query) {
            my $result = $query->result;
            like $result->row_next->[0], qr{^\d+$};
            exit;
        }
        $drizzle->con_wait;
    }
    exit;
}

mainloop();



