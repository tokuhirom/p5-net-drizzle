use strict;
use warnings;
use Test::More tests => 9;
use Net::Drizzle;

my $dr = Net::Drizzle->new();
ok $dr;

is $dr->host, '127.0.0.1';
is $dr->port, 4427;
$dr->set_tcp('localhost', 10010);
is $dr->host, 'localhost';
is $dr->port, 10010;

is $dr->user, 'root';
is $dr->password, '';
$dr->set_auth('root', 'mypw');
is $dr->user, 'root';
is $dr->password, 'mypw';

