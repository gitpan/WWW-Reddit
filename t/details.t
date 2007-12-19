#!/usr/bin/env perl

use Test::More tests => 4;
use Data::Dumper;

use WWW::Reddit;

my $r = WWW::Reddit->new( username => $username,
                          password => $password );

$r->set_id( '61qam' );

my $details = $r->details();

ok( exists $details->{'submitted'}, 'submitted' );
ok( exists $details->{'points'},    'points' );
ok( exists $details->{'upvotes'},   'upvotes' );
ok( exists $details->{'downvotes'}, 'downvotes' );

diag( Data::Dumper->Dump( [ $details ], [ 'details' ] ) );

