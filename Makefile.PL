use inc::Module::Install;
name 'Net-Drizzle';
all_from 'lib/Net/Drizzle.pm';
no_index 'tools/extlib/';

can_cc or die "This module requires a C compiler";

makemaker_args(
    OBJECT  => '$(O_FILES)',
    LIBS    => '-ldrizzle',
    CCFLAGS => '-L/tmp/libdrizzle-0.3/.libs -g -Wall -Wextra -std=c99',
    clean   => {
        FILES => q{
            *.stackdump
            *.gcov *.gcda *.gcno
            *.out
            nytprof
            cover_db
        },
    },
);

tests 't/*.t';
recursive_author_tests('xt');
render_mt('Drizzle.xs.tt' => 'Drizzle.xs');

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
