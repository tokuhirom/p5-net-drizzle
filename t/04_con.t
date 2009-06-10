use strict;
use warnings;
use Test::More tests => 2;
use Net::Drizzle;

my $dr = Net::Drizzle->new();
{
    my $con = $dr->con_clone();
    isa_ok $con, "Net::Drizzle::Connection";
}
ok 'finished';
