use strict;
use warnings;
use Test::More;
use Net::Drizzle ':constants';

my $cons = 10;
plan tests => ($cons) * 5;

my $query = "SELECT table_schema,table_name FROM tables";

my $dr = Net::Drizzle->new
                     ->add_options(DRIZZLE_NON_BLOCKING);
my $c1 = $dr->con_create
            ->add_options(DRIZZLE_CON_MYSQL)
            ->set_db("information_schema");
for (1..$cons) {
    $c1->clone->query_add($query);
}
my $queries = $cons;
while (1) {
    my ($ret, $query) = $dr->query_run();
    if ($query) {
        $queries--;
        is $query->string, 'SELECT table_schema,table_name FROM tables', 'query';
        my $result = $query->result;
        check_result($result);
        if ($queries == 0) {
            last;
        }
    }
    $dr->con_wait();
}

sub check_result {
    my $s = shift;
    is $s->error_code, 0;
    is $s->error, '';
    is $s->info, '';
    is $s->column_count, 2;
}

