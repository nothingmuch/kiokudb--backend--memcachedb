use inc::Module::Install;
name 'KiokuDB-Backend-Memcachedb';
all_from 'lib/KiokuDB/Backend/Memcachedb.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
