#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'WWW::Reddit' ) || print "Bail out!\n";
}

diag( "Testing WWW::Reddit $WWW::Reddit::VERSION, Perl $], $^X" );
