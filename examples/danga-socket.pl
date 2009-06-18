use strict;
use warnings;
use Danga::Socket;
use Danga::Socket::Callback;
use IO::Socket::INET;
use Socket qw/TCP_NODELAY IPPROTO_TCP/;
use IO::Handle;
use Net::Drizzle ':constants';
use Term::ANSIColor ':constants';

die "THIS SCRIPT DOES NOT WORKS YET";

my $port = 9429;
my $ssock = IO::Socket::INET->new(
    LocalPort => $port,
    Type      => Socket::SOCK_STREAM,
    Proto     => Socket::IPPROTO_TCP,
    Blocking  => 0,
    Reuse     => 1,
    Listen    => 10
) or die "Error creating socket: $@\n";
$ssock->blocking(0);

sub msg { print "@_\n" }

my $drizzle = Net::Drizzle->new()
                          ->add_options(DRIZZLE_NON_BLOCKING);
my $con = $drizzle->con_create()
                  ->add_options(DRIZZLE_CON_MYSQL)
                  ->set_charset(8)
                  ->set_db('test_net_drizzle_crowler');

Danga::Socket->AddOtherFds(
    fileno($ssock) => sub {
        my $csock = $ssock->accept or return;
        IO::Handle::blocking( $ssock, 0 );
        $csock->autoflush(1);
        $csock->blocking(0);
        setsockopt( $csock, IPPROTO_TCP, TCP_NODELAY, pack( "l", 1 ) )
                    or die;

        setsockopt( $csock, Socket::IPPROTO_TCP, TCP_NODELAY, pack( "l", 1 ) )
          or die;

        OreOre::Danga::Socket::Admin->new($csock);
    }
);

=pod
                OreOre::Danga::Socket::Drizzle->new(
                    con     => $con->clone(),
                    query   => 'SELECT COUNT(*) FROM entry',
                    callback => sub {
                        my $result = shift;
                        my $count = $result->row_next->[0];
                        print BLUE, "current rows: $count\n", RESET;
                    },
                );
=cut

{
    my $nc = $con->clone();
    my $q = $nc->query_add('SELECT COUNT(*) FROM entry');
    use IO::Poll qw/POLLIN POLLOUT/;
    while (1) {
        $con->drizzle->con_wait;
        # $nc->set_revents( POLLIN|POLLOUT );
        my ($ret, $query) = $drizzle->query_run;
        warn $ret;
        if ($query) {
            warn $query->result->row_next->[0];
            last;
        }
    }
}

=pod
{
    my $nc = $con->clone;
    my $sql = 'SELECT COUNT(*) FROM entry';
    $nc->set_data({
        callback => sub {
            my $result = shift;
            warn("finished\n");
            warn $result->row_next->[0];
            $nc->close();
            undef $nc;
        }
    });
    $nc->query_add($sql);
    my ($ret, $query) = $drizzle->query_run;
    if ($query) {
    }
    warn $ret;
    warn $nc->fd;
    Danga::Socket->AddOtherFds(
        $nc->fd() => sub {
            $drizzle->con_wait;
            my ($ret, $query) = $drizzle->query_run;
            if ($query) {
                $query->con->data->{callback}->($query->result);
            }
        }
    );
}
=cut
#       my $nnc = $con->clone;
#       OreOre::Danga::Socket::Drizzle->new(
#           con     => $nnc,
#           query   => $sql,
#           callback => sub {
#               my $result = shift;
#               warn "FINISHED";
#               warn "CLOSE";
#               # warn $self->close();
#               # my $count = $result->row_next->[0];
#               # print BLUE, "current rows: $count\n", RESET;
#           },
#       );

warn "ready to connect";
Danga::Socket->EventLoop();

{
    package OreOre::Danga::Socket::Admin;
    use base 'Danga::Socket';
    use fields 'buffer';

    sub new {
        my ($class, $sock) = @_;
        my $self = $class->SUPER::new($sock);
        $self->watch_read(1);
        $self->watch_write(1);
        $self;
    }

    sub event_read {
        my $self = shift;
        warn "EVENT READ";
        my $dat = $self->read(20_000);
        return $self->close unless defined $dat;
        $self->{buffer} .= $$dat;
        while ($self->{buffer} =~ s/^(.*?)\r?\n//) {
            $self->_insert($1);
        }
    }

    sub _insert {
        my ($self, $dat) = @_;

#       # my $sql = 'INSERT INTO echo (message) values ("'.$drizzle->escape($dat).'")';
        my $sql = 'SELECT COUNT(*) FROM entry';
#       my $nc = $con->clone();
#       $nc->set_data({
#           callback => sub {
#               $self->write("finished\n");
#               $nc->close();
#               undef $nc;
#           }
#       });
#       $nc->query_add($sql);
#       my ($ret, $query) = $drizzle->query_run;
#       if ($query) {
#                   $query->con->data->{callback}->($query->result);
#       }
#       warn "SEND QUERY $sql";
#       Danga::Socket->AddOtherFds(
#           $nc->fd() => sub {
#               warn "WAIT!";
#               $drizzle->con_wait;
#               my ($ret, $query) = $drizzle->query_run;
#               warn $ret;
#               $self->write("HO $ret\n");
#               if ($query) {
#                   $query->con->data->{callback}->($query->result);
#               }
#           }
#       );
        my $nc = $con->clone;
        $nc->query_add($sql);
        my $d = OreOre::Danga::Socket::Drizzle->new(
            con => $nc,
            query => $sql,
            callback => sub {
                die "CALLBACK";
            },
        );
        warn "BEFORE SOON";
        $d->_soon();
        warn "i can reach here";
    }
}

{
    package OreOre::Danga::Socket::Drizzle;
    use strict;
    use warnings;
    use base 'Danga::Socket';
    use fields qw(con callback);
    use Net::Drizzle ':constants';
    use IO::Poll qw/POLLIN POLLOUT/;
    use IO::Handle;
    use Term::ANSIColor ':constants';

my $foo;
    sub new {
        my OreOre::Danga::Socket::Drizzle $self = shift;
        warn "INITIALIZING";
        my %args = @_;
        $self = fields::new($self) unless ref $self;
        $self->{con} = $args{con};
        warn $self->{con};
        printf STDERR "CON: 0x%X\n", ${$self->{con}};
        $self->{callback} = $args{callback};

        # my $query = $args{con}->query_add($args{query});
        # $foo->{query} = $query;
        # $foo->{res} = $query->result;
        $foo->{con} = $con;
        $foo->{fh} = $self->{con}->fh;
        # warn "RUN $args{query}";
        while (1) {
            my $ret = $self->handle_once(undef);
            if ($ret == DRIZZLE_RETURN_IO_WAIT) {
                last;
            }
        }

        die "cannot connect?" if $self->{con}->fd < 0;
        $self->SUPER::new( $self->{con}->fh );
        $self->watch_read(1);
        $self->watch_write(1);


        return $self;
    }

    sub event_read {
        my $self = shift;
        warn YELLOW, "EVENT READ", RESET;

        $self->_soon();

        $self->handle_once(POLLOUT);
    }

    sub event_write {
        my $self = shift;

        $self->_soon();

        $self->handle_once(POLLIN);
    }

    sub handle_once {
        my ($self, $mode) = @_;


        $drizzle->con_wait;
        if (defined $mode) {
        #   $self->{con}->set_revents( POLLIN|POLLOUT );
        }
        my ($ret, $query) = $drizzle->query_run();
        if ($ret != DRIZZLE_RETURN_IO_WAIT && $ret != DRIZZLE_RETURN_OK) {
            die "query error: " . $drizzle->error(). '('.$drizzle->error_code .')';
        }
        if ($query) {
            warn "OK";
            my $result = $query->result;
            $self->close();
            my $callback = $self->{callback};
            if (defined $callback) {
                $callback->($query->result);
            }
            main::msg("finished query !!");
        }
        return $ret;
    }

    sub _soon {
        while (1) {
            my ($ret, $query) = $drizzle->query_run;
            $drizzle->con_wait;
            # $nc->set_revents( POLLIN|POLLOUT );
            warn $ret if $ret;
            warn RED, "PARSE ERR!", RESET if $ret==17;
            warn '.';
            if ($query) {
                warn BLUE, $query->result->row_next->[0], RESET;
                die;
                last;
            }
        }
    }
}


