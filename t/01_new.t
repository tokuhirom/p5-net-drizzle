use strict;
use warnings;
use Test::More tests => 2;
use Net::Drizzle;

my $dr = Net::Drizzle->new();
ok $dr;
can_ok $dr, 'DESTROY';

