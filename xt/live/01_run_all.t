use strict;
use warnings;
use Test::More tests => 1;
use Net::Drizzle;

my $dr = Net::Drizzle->new;
my $c1 = $dr->con_clone;
$dr->query_add($c1, "SELECT table_schema,table_name FROM tables");
$dr->query_run_all();
