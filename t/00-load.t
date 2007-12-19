#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'WWW::Reddit' );
}

diag( "Testing WWW::Reddit $WWW::Reddit::VERSION, Perl $], $^X" );
