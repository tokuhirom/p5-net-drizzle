use strict;
use warnings;
use Test::More tests => 4;
use Net::Drizzle;

my $dr = Net::Drizzle->new;
my $c1 = $dr->con_create;
$c1->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL);
$c1->set_db("information_schema");
my $s1 = $c1->query_add("SELECT table_schema,table_name FROM tables");
$dr->query_run_all();
is $s1->error_code, 0;
is $s1->error, '';
is $s1->info, '';
is $s1->column_count, 2;

