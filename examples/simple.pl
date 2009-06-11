use strict;
use warnings;
use Net::Drizzle;

my @s;

my $con = Net::Drizzle::Connection->new;
$con->add_options(Net::Drizzle::DRIZZLE_CON_MYSQL);
$con->set_db("information_schema");
my $s = $con->query_str("SELECT table_schema,table_name FROM tables");
$s->buffer;

die if $s->error_code != 0;
while (my $row = $s->next) {
    print "@$row\n";
}

