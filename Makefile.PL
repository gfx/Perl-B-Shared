use strict;
use warnings;
use inc::Module::Install;

name 'B-Shared';
all_from 'lib/B/Shared.pm';

use_ppport 3.19;
cc_warnings;

test_requires 'Test::More' => 0.62;

tests 't/*.t';
author_tests 'xt';

clean_files q(
	B-Shared-* *.stackdump
	*.gcda *.gcno *.gcov
	nytprof *.out
	cover_db
);

WriteAll check_nmake => 0;
