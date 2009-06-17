use strict;
use warnings;
use Test::More;
use Net::Drizzle;

my $cons = 10;
plan tests => ($cons+1) * 4;

my $query = "SELECT table_schema,table_name FROM tables";

my $dr = Net::Drizzle->new;
my @sth;
my $c1 = $dr->con_create;
$c1->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL);
$c1->set_db("information_schema");
my $s1 = $c1->query_add($query);
for (1..$cons) {
    my $c = $c1->clone;
    push @sth, $c->query_add($query);
}
$dr->query_run_all();
check_result($s1->result);
check_result($_->result) for @sth;

sub check_result {
    my $s = shift;
    is $s->error_code, 0;
    is $s->error, '';
    is $s->info, '';
    is $s->column_count, 2;
}

