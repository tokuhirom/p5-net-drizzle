use strict;
use warnings;
use Net::Drizzle ':constants';
use HTTP::Engine;
use Text::MicroTemplate 'render_mt';
use HTTP::Request::Common;
use POE qw(
    Component::Client::HTTP
    Session
);
use IO::Handle;
use Carp ();
use Term::ANSIColor ':constants';

use constant  {
    CLIENT_QUERY  => 1,
    CLIENT_FIELDS => 2,
};


use constant POLLIN        => 1;
use constant POLLOUT       => 4;
use constant POLLERR       => 8;
use constant POLLHUP       => 16;
use constant POLLNVAL      => 32;

{
    my $cache = {};
    sub fd2fh {
        my $fd = shift;
        Carp::confess("invalid fd $fd") if $fd < 0;
        $cache->{$fd} ||= do {
            my $fh = IO::Handle->new;
            $fh->fdopen($fd, 'w+');
            $fh;
        };
    }
}

=pod

please run the following queries before run this script.

    create database if not exists test_net_drizzle_crowler;
    use test_net_drizzle_crowler;
    create table if not exists entry (url text, body text) engine=innodb default charset=utf8;

=cut

sub DEBUG { print "@_\n" if $ENV{DEBUG} }
sub DEBUG2 { print "@_\n" if $ENV{DEBUG2} }
sub msg { print "@_\n" }

my @urls = qw(
    http://livedoor.com/
    http://www.hatena.ne.jp/
    http://mbga.jp/
    http://gree.jp/
);

POE::Session->create(
    inline_states => {
        _start => sub {
            my $drizzle = Net::Drizzle->new()
                                       ->add_options(DRIZZLE_NON_BLOCKING);
            $_[HEAP]->{drizzle} = $drizzle;
            $_[KERNEL]->alias_set('drizzle');

            my $con = $drizzle->con_create()
                              ->add_options(DRIZZLE_CON_MYSQL)
                              ->set_db('test_net_drizzle_crowler');
            $_[HEAP]->{con} = $con;
        },
        query => sub {
            my ($query, $binds, $callback) = @_[ARG0, ARG1, ARG2];
            my $drizzle = $_[HEAP]->{drizzle};
            my $con     = $_[HEAP]->{con};
            my $i=0;
            $query =~ s{\?}{'"'.$drizzle->escape($binds->[$i++]).'"'}eg;
            msg("SEND QUERY '$query'");

            my $newcon = $con->clone();
            my $container = {
                query    => $query,
                con      => $newcon,
                state    => CLIENT_QUERY,
                sender   => $_[SENDER]->ID,
                callback => $callback,
            };
            $newcon->set_data($container);
            client_process($container); # attameru
            $_[KERNEL]->select(fd2fh($newcon->fd), 'handle_select', 'handle_select', undef, $container);
        },
        handle_select => sub {
            my ($mode, $container) = ($_[ARG1], $_[ARG2]);
            return unless defined $container;
            return unless defined $container->{con};

            DEBUG("handle_select $mode, $container");
            my $drizzle = $_[HEAP]->{drizzle};
            $container->{con}->set_revents( $mode == 0 ? POLLIN : POLLOUT );
            while (my $con = $drizzle->con_ready()) {
                DEBUG("CON_READY --");
                my $container = $con->data;
                DEBUG("MISSING CONTAINER: $con") unless $container;
                if (client_process($container) == 0) {
                    # succeeded
                    $_[KERNEL]->select_pause_read(fd2fh($container->{con}->fd));
                    $_[KERNEL]->select_pause_write(fd2fh($container->{con}->fd));
                    my ($callback, $sender) = ($container->{callback}, $container->{sender});
                    if (defined $callback) {
                        DEBUG2("CALLBACK TO $callback, $sender");
                        $_[KERNEL]->post($sender, $callback, $container->{result});
                    }
                    undef $container->{con};
                    undef $container;
                    msg("finished query !!");
                }
            }
        },
    },
);

POE::Component::Client::HTTP->spawn(
    Agent           => 'Net::Drizzle/ExampleScript',
    Alias           => 'ua',                    # defaults to 'weeble'
    Timeout         => 10,
    FollowRedirects => 2,
);

POE::Session->create(
    inline_states => {
        _start => sub {
        warn "OK";
            DEBUG2("START COUNT STATE");
            $_[KERNEL]->yield( 'get' );
        },
        get => sub {
            DEBUG2("GET NEW COUNT");
            $_[KERNEL]->post('drizzle', 'query', 'SELECT COUNT(*) FROM entry', [], 'callback' );

            $_[KERNEL]->delay( 'get' => 1 );
        },
        callback => sub {
            my $result = $_[ARG0];
            my $count = $result->row_next->[0];
            print BLUE, "current rows: $count\n", RESET;
        }
    },
);

# main session
POE::Session->create(
    inline_states => {
        _start => sub {
            for my $url (@urls) {
                msg("enqueue $url");
                $_[KERNEL]->post('ua', 'request', 'got_response', GET($url));
            }
        },
        got_response => sub {
            my ($request_packet, $response_packet) = @_[ARG0, ARG1];
            my $request_object  = $request_packet->[0];
            my $response_object = $response_packet->[0];

            $_[KERNEL]->post('drizzle', 'query', 'INSERT INTO entry (url, body) VALUES (?, ?);',
                [ $request_object->uri, substr($response_object->content, 0, 20)]);
        },
    },
);

POE::Kernel->run;

sub client_process {
    my $container = shift;
    die "oops? invalid container: $container" unless ref $container;
    my $func = +{
        CLIENT_QUERY()  => 'client_query',
        CLIENT_FIELDS() => 'client_fields',
    }->{$container->{state}};
    no strict 'refs';
    my $code = *{$func} or die "missing func? $func";
    $code->($container);
}

sub client_query {
    my $container = shift;
    my ($ret, $result) = $container->{con}->query($container->{query});
    $container->{result} = $result;
    if ($ret == DRIZZLE_RETURN_IO_WAIT) {
        DEBUG("IO_WAIT");
        return 1;
    } elsif ($ret != DRIZZLE_RETURN_OK) {
        die "error occured at drizzle_query: $ret, ".$container->{con}->drizzle->error;
    }

    if ($result->column_count != 0) {
        DEBUG("HAS FIELDS");
        $container->{state} = CLIENT_FIELDS;
        return client_fields($container);
    } else {
        return 0;
    }
}

sub client_fields {
    my $container = shift;
    DEBUG("CLIENT_FIELDS");
    my $result = $container->{result};
    my $ret = $result->buffer;
    if ($ret == DRIZZLE_RETURN_IO_WAIT) {
        DEBUG("IO_WAIT");
        return 1;
    } elsif ($ret != DRIZZLE_RETURN_OK) {
        die "error occured at drizzle_query: $ret";
    }

    return 0;
}
