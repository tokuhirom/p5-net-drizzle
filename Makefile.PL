use inc::Module::Install;
name 'Net-Drizzle';
all_from 'lib/Net/Drizzle.pm';

can_cc or die "This module requires a C compiler";

makemaker_args(
    OBJECT  => '$(O_FILES)',
    LIBS    => '-lstdc++ -ldrizzle',
    CCFLAGS => '-g -Wall',
    CC      => 'g++',
    LD      => 'g++',
    XSPOT   => '-C++',
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
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
