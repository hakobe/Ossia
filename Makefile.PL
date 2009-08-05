use inc::Module::Install;
name 'Ossia';
all_from 'lib/Ossia.pm';

requires $_ for (qw/ /);

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
