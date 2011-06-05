use inc::Module::Install;
name 'Log-Plugin-Syslog';
all_from 'lib/Log/Plugin/Syslog.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
