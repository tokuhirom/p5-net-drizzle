use strict;
use warnings;
use Test::More;
use Net::Drizzle;

plan tests => 4;

my $query = "SELECT table_schema,table_name FROM tables";

my $con = Net::Drizzle::Connection->new
                                  ->set_tcp('127.0.0.1', '3306')
                                  ->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL)
                                  ->set_db("information_schema");
my $sth = $con->query_str($query);
$sth->buffer();
check_result($sth);

sub check_result {
    my $s = shift;
    is $s->error_code, 0;
    is $s->error, '';
    is $s->info, '';
    is $s->column_count, 2;
}

