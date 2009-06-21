use Modern::Perl;
use FindBin;
use Path::Class;

&main;exit;

BEGIN {
    package DocParser;
    use Mouse;
    use constant {
        FIRST => 0,
        GENERAL => 3,
        BOOT => 4,
        FUNC  => 1,
        INNER => 2,
    };

    has state => (
        is => 'rw',
        isa => 'Int',
        default => sub { FIRST },
    );

    has func_name => (
        is => 'rw',
        isa => 'Str',
    );

    has type => (
        is => 'rw',
        isa => 'Str',
    );

    has package => (
        is => 'rw',
        isa => 'Str',
    );

    has args => (
        is => 'rw',
        isa => 'ArrayRef[Str]',
    );

    has result => (
        is => 'rw',
        isa => 'HashRef',
        default => sub { +{} },
    );

    has inner_buffer => (
        is => 'rw',
        isa => 'ArrayRef[Str]',
        default => sub { +[] },
    );

    sub dbg { }

    sub parse {
        my ($self, $line) = @_;
        my $meth = {
            FIRST() => 'first',
            GENERAL() => 'general',
            FUNC()  => 'func',
            BOOT() => 'boot',
            INNER() => 'inner',
        }->{$self->state};
        die "unknown state: @{[ $self->state ]}" unless defined $meth;
        $self->$meth($line);
    }

    sub first {
        my ($self, $line) = @_;
        if ($line =~ /^MODULE/) {
            $self->state(GENERAL);
            $self->general($line);
        }
    }

    sub general {
        my ($self, $line) = @_;
        given ($line) {
            when (/PACKAGE\s*=\s*(.+)$/) {
                my $package = $1;
                $self->package($package);
                dbg "package $package;";
            }
            when (/^PROTOTYPES/) {
                # nop
            }
            when (/^BOOT:/) {
                $self->state(BOOT);
            }
            when (/^(\S.+)$/) {
                my $type = $1;
                dbg " type $1";
                $self->type($type);
                $self->state(FUNC);
            }
        }
    }

    sub boot {
        my ($self, $line) = @_;
        if ($line =~ /^\S/) {
            $self->state(GENERAL);
            $self->general($line);
        }
    }

    sub func {
        my ($self, $line) = @_;
        if ($line =~ /^(\S+)\((.+?)\)/) {
            my $funcname = $1;
            my $args = $2;
            dbg "  func $funcname";
            dbg "   args $args";
            $self->func_name($funcname);
            $self->args([map { s/^\s*//; $_ } split /,/, $args]);
            $self->state(INNER);
        }
    }

    sub inner {
        my ($self, $line) = @_;
        given ($line) {
            when (/^(?:(?:PP)?CODE|OUTPUT):/) {
                # nop
            }
            when (/^\S/) {
                my $inner = join "\n", @{$self->inner_buffer};
                dbg $inner;
                say $inner;
                my $doc = do {
                    if ($inner =~ m{/\*\*(.+?)?\*/}ms) {
                        my $a = $1;
                        $a =~ s/^\s*\* ?//mg;
                        $a;
                    } else {
                        # nop.
                    }
                };
                push @{$self->result->{$self->package}}, +{
                    args => $self->args,
                    name => $self->func_name,
                    doc  => $doc,
                    type => $self->type,
                };
                $self->inner_buffer(+[]);
                $self->state(GENERAL);
                $self->general($line);
            }
            default {
                push @{$self->inner_buffer}, $line;
            }
        }
    }

    __PACKAGE__->meta->make_immutable;
}

{
    package DocWriter;
    use Mouse;
    use Template;
    use Path::Class;
    sub write {
        my ($class, $input, $data, $output) = @_;
        my $tt = Template->new(
            ABSOLUTE => 1,
        );
        $tt->process($input, $data, $output) or die $tt->error;
    }
}

sub main {
    my $file = file($FindBin::Bin, '..', 'Drizzle.xs')->slurp;
    my $parser = DocParser->new;
    for my $line (split /\n/, $file) {
        $parser->parse($line);
    }
    for my $type (qw/Column Query/) {
        DocWriter->write(
            file($FindBin::Bin, 'tmpl', "${type}.tt")->stringify,
            +{
                methods => $parser->result->{"Net::Drizzle::${type}"}
            },
            file($FindBin::Bin, '..', 'lib', 'Net', 'Drizzle', "${type}.pm")->stringify,
        );
    }
}

