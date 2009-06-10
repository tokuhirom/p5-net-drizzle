use strict;
use warnings;
use Net::Drizzle;

my @s;

my $dr = Net::Drizzle->new;
my $c1 = $dr->con_create;
$c1->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL);
$c1->set_db("information_schema");
for (0..10) {
    my $c = $c1->clone;
    push @s, $c->query_add("SELECT table_schema,table_name FROM tables");
}

$dr->query_run_all();

for my $i (0..10) {
    my $s = $s[$i];

    die if $s->error_code != 0;
    while (my $row = $s->next) {
        print "$i:@$row\n";
    }
}

