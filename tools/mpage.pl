use strict;
use warnings;
use FindBin;
use File::Spec;
use lib File::Spec->catfile($FindBin::Bin, 'extlib', 'lib', 'perl5');
use Text::MicroTemplate;

die "Usage: $0 src dst" unless @ARGV == 2;
my ($src, $dst) = @ARGV;

&main;exit;

sub main {
    output(render(slurp($src)) => $dst);
}

sub render {
    my $tmpl = shift;
    my $mt = Text::MicroTemplate->new(
        template => $tmpl,
        escape_func => undef,
    );
    my $code = $mt->code;
    $code = eval $code;
    die $@ if $@;
    $code->();
}

sub slurp {
    my $fname = shift;
    open my $fh, '<', $fname or die $!;
    my $out = do { local $/; <$fh> };
    close $fh;
    return $out;
}

sub output {
    my ($content, $ofname) = @_;
    open my $fh, '>', $ofname or die "cannot open file: $ofname: $!";
    print $fh $content;
    close $fh;
}

