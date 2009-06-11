use strict;
use warnings;
use Net::Drizzle;
use Benchmark ':all';

my $limit = 10;

cmpthese(
    1000 => {
        concurrent => \&concurrent,
        # serial     => \&serial,
    },
);


sub serial {
    for my $i (0..$limit) {
        my $con = Net::Drizzle::Connection->new;
        $con->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL);
        $con->set_db("information_schema");
        my $s = $con->query_str("SELECT table_schema,table_name FROM tables");
        $s->buffer;

        die if $s->error_code != 0;
        while (my $row = $s->row_next) {
            # nop
        }
    }
}

sub concurrent {
    my @s;
    my $dr = Net::Drizzle->new;
    my $c1 = $dr->con_create;
    $c1->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL);
    $c1->set_db("information_schema");
    for (0..$limit) {
        my $c = $c1->clone;
        push @s, $c->query_add("SELECT table_schema,table_name FROM tables");
    }

    $dr->query_run_all();

    for my $i (0..$limit) {
        my $s = $s[$i];

        die if $s->error_code != 0;
        while (my $row = $s->row_next) {
            # nop
        }
    }
}
