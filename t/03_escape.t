use strict;
use warnings;
use Test::More tests => 1;
use Net::Drizzle;

my $dr = Net::Drizzle->new();
is $dr->escape(q{"}), q{\\"};

