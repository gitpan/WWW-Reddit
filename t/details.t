#!/usr/bin/env perl

use Test::More tests => 17;
use Data::Dumper;
use Test::MockObject::Extends;

use WWW::Reddit;

my $r = WWW::Reddit->new( username => '',
                          password => '' );

# with no ID, we should get undef
$details = $r->details();
ok( ! defined $details, 'details returns undef without ID' ) or
  diag( Data::Dumper->Dump( [ $details ], [ 'details' ] ) );

my $id = '63iup';
$r->set_id( $id );

my $mech = $r->get_mech();
$mech = Test::MockObject::Extends->new( $mech );
$mech->set_always( 'get', '' ); # stop Mech from actually fetching things
$mech->set_always( 'content', <DATA> ); # return our page from __DATA__
$r->set_mech( $mech );

my $details = $r->details();

# $details = {
#              'submitted' => '20 Dec 2007',
#              'points'    => '6',
#              'upvotes'   => '6',
#              'downvotes' => '0'
#              'title'     => 'perl module to interact with reddit - WWW::Reddit',
#              'url'       => 'http://search.cpan.org/~amoore/WWW-Reddit-0.02/',
#            };

is( scalar( keys %$details ), 6, 'details returned 6 things' );
is( $details->{'submitted'}, '20 Dec 2007',                                       'submitted' );
is( $details->{'points'},    '6',                                                 'points' );
is( $details->{'upvotes'},   '6',                                                 'upvotes' );
is( $details->{'downvotes'}, '0',                                                 'downvotes' );
is( $details->{'title'},     'perl module to interact with reddit - WWW::Reddit', 'title' );
is( $details->{'url'},       'http://search.cpan.org/~amoore/WWW-Reddit-0.02/',   'url' );

# diag( Data::Dumper->Dump( [ $details ], [ 'details' ] ) );


# with no ID, we should get undef
$r->set_id( undef );
$details = $r->details();
ok( ! defined $details, 'details returns undef without ID' );

# Now, let's see if it works if we pass in the ID.
$details = $r->details( $id );
is( $r->get_id(), $id, 'we have set the ID' );
is( scalar( keys %$details ), 6, 'details returned 6 things' );
is( $details->{'submitted'}, '20 Dec 2007',                                       'submitted' );
is( $details->{'points'},    '6',                                                 'points' );
is( $details->{'upvotes'},   '6',                                                 'upvotes' );
is( $details->{'downvotes'}, '0',                                                 'downvotes' );
is( $details->{'title'},     'perl module to interact with reddit - WWW::Reddit', 'title' );
is( $details->{'url'},       'http://search.cpan.org/~amoore/WWW-Reddit-0.02/',   'url' );





__DATA__;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en" ><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8' /><title>programming: perl module to interact with reddit - WWW::Reddit</title><script type="text/javascript">var a = new Image(); a.src = "http://reallystatic.reddit.com/static/aupmod.png"; var b = new Image(); b.src = "http://reallystatic.reddit.com/static/adownmod.png"; var logged = 'amoore'; var _global_point_tag = ['point', 'points']; var modhash = 'trjyky3smtf927bf4f76cc691c128f4a1d4b7e39abc9e6b8b7';</script><script src="http://reallystatic.reddit.com/static/json.js?v=25c844a4fc0be29be4d7e99264a08aad" type="text/javascript"></script><script src="http://reallystatic.reddit.com/static/reddit.js?v=db695a9d8966f30ecbd2b90925da7899" type="text/javascript"></script><link rel='stylesheet' href="http://reallystatic.reddit.com/static/reddit.css?v=219d6a20c7d79d007ec10e46f24768d7" type="text/css" /><link rel='shortcut icon' href="http://reallystatic.reddit.com/static/favicon.ico" type="image/x-icon" /><script type="text/javascript">var class_dict = { t3: Link, t1: Comment, t4: Message }; window.onload = init; window.onpageshow = function(evt) { if (evt.persisted) init() }; var _global_fetching_tag = 'fetching title...'; var _global_submitting_tag = 'submitting...'; var _global_loading_tag = 'loading...';</script></head><body><table id="topbar"><tr><td rowspan="2" valign="top"><img id="header" src="http://static.reddit.com/reddit_programming.png" alt="programming" usemap="#header" /><map name="header" id="reddit_header"><area shape="rect" coords="0,0,33,40" href="/" alt="back to hot"/><area shape="rect" coords="34,0,120,40" href="http://reddit.com" alt="to reddit.com"/></map></td><td colspan="2" class="wide nowrap"><div class="topmenu menu"><a href="/user/amoore/" >amoore</a>(20) |&nbsp;<a href="/message/inbox" class="" ><img src="http://reallystatic.reddit.com/static/mailgray.png" alt="messages"/></a>&nbsp;|&nbsp;<a href="/prefs" >prefs</a>&nbsp;|&nbsp;<a href="/submit" >submit</a>&nbsp;|&nbsp;<a href="/help/" >help</a>&nbsp;|&nbsp;<a href="/blog/" >blog</a>&nbsp;|&nbsp;<a href="/logout" >logout</a></div></td></tr><tr><td valign="top" class="wide"><div id="topstrip" ><a href="/" class="menu-item" >hot</a><a href="/new" class="menu-item" >new</a><a href="/browse" class="menu-item" >browse</a><a href="/saved" class="menu-item" >saved</a><a href="/recommended" class="menu-item" >recommended</a><a href="/stats" class="menu-item" >stats</a></div></td><td valign="top" class="nowrap"><form id="searchform" action="/search" method="get" style=""><div style="display:inline;"><input class="txt" style="vertical-align: bottom" type="text" name="q" value="" /><button class="btn" type="submit">search</button></div></form></td></tr></table><div class="main"><div id="siteTable"><div id="pre_t3_63iup" class="odd"></div><div id="thingrow_t3_63iup" class="odd"><div class="numbercol" style="width:0ex;" id="thingCol1_t3_63iup"></div><div id="thingCol2_t3_63iup" class="midcol"><div id="up_t3_63iup" class="arrow upmod" onclick="javascript:mod('t3_63iup', 1)" style=""></div><div id="down_t3_63iup" class="arrow down" onclick="javascript:mod('t3_63iup', 0)" style=""></div></div><div id="thingCol3_t3_63iup" style="margin-left: 3ex; margin-top: 0px; "><div id="entry_t3_63iup" class="entry"><div id="titlerow_t3_63iup" class="titlerow"><a id="title_t3_63iup" class="title loggedin " href="http://search.cpan.org/~amoore/WWW-Reddit-0.02/" >perl module to interact with reddit - WWW::Reddit</a>&#32;<span class="little" >(search.cpan.org)</span></div><div class="little"><span class="inside" id="score_t3_63iup">6 points</span>&nbsp;posted&nbsp;17 minutes&nbsp;ago&nbsp;by&nbsp;<a class='friend' href="/user/amoore/">amoore</a><span id="comment_t3_63iup"><a href="http://programming.reddit.com/info/63iup/comments/" class="bylink" target="_parent" >3 comments</a></span><form class="delform" action="/post/save" method="post"><div id="save_t3_63iup" style="display:inline;"><input type="hidden" name="executed" value="saved" /><input type="hidden" name="id" value="t3_63iup" /><a href="" class="bylink" onclick="return change_state(this, 'save');" id="save_t3_63iup_a">save</a></div></form><form class="delform" action="/post/hide" method="post"><div id="hide_t3_63iup" style="display:inline;"><input type="hidden" name="executed" value="hidden" /><input type="hidden" name="id" value="t3_63iup" /><a href="" class="bylink" onclick="return change_state(this, 'hide');" id="hide_t3_63iup_a">hide</a></div></form><form class="delform" action="/post/delete" method="post"><div id="delete_t3_63iup" style="display:inline;"><input type="hidden" name="executed" value="deleted" /><input type="hidden" name="id" value="t3_63iup" /><input type="hidden" name="yes" value="yes" /><input type="hidden" name="question" value="are you sure?" /><input type="hidden" name="no" value="no" /><a href="" class="bylink" onclick="return deletetoggle(this, 'del');" id="delete_t3_63iup_a">delete</a></div></form></div></div><div id="child_t3_63iup" class="thing-children" ></div></div><div style="clear: left"></div></div></div><div class="main"><div id="usermenu" ><span class="username">info</span><a href="/info/63iup/comments" >comments</a><a href="/info/63iup/related" >related</a><a href="/info/63iup/details" class="sel-user" >details</a></div><div class="main"><table class='details'><tr><td class='profline'>submitted</td><td>20 Dec 2007</td></tr><tr><td class='profline'>points</td><td>6</td></tr><tr><td class='profline'>up votes</td><td>6</td></tr><tr><td class='profline'>down votes</td><td>0</td></tr></table></div><div class="footer"></div></div><div class="footer"></div></div><div class="footer"><p class="menu"><a href="/feedback">feedback</a>&nbsp;|&nbsp;<a href="/bookmarklets">bookmarklets</a>&nbsp;|&nbsp;<a href="/buttons">buttons</a>&nbsp;|&nbsp;<a href="/widget">widget</a>&nbsp;|&nbsp;<a href="/store">store</a>&nbsp;|&nbsp;<a href="/ad_inq">advertise</a></p><p class="wired"><a href="http://wired.com"><img src="http://reallystatic.reddit.com/static/wired_w.png" alt="wired" /></a>&nbsp;<a href="http://wired.com">WIRED.com</a>&nbsp; - &nbsp;<a href="http://howto.wired.com">WIRED How-To</a></p><p class="bottommenu">Use of this site constitutes acceptance of our&#32;<a href="http://reddit.com/help/useragreement" >User Agreement</a>&#32;and&#32;<a href="http://reddit.com/help/privacypolicy" >Privacy Policy</a>(c) 2007 CondeNet, Inc. All rights reserved.</p></div></body></html>

