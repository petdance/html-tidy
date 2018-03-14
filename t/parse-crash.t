#!/usr/bin/perl -T

use 5.010001;
use warnings;
use strict;

# From a crashy-crash that Bob Diss and Mike O'Regan were tracking down.
# I've been unable to get it to fail again, but we might as well make a
# test out of it.

use Test::More tests => 2;

use HTML::Tidy;

my $html = do { local $/ = undef; <DATA> };

my $tidy = HTML::Tidy->new;
isa_ok( $tidy, 'HTML::Tidy' );
$tidy->ignore( type => TIDY_INFO );
$tidy->clean( $html );

my @expected = split( /\n/, <<'HERE' );
 (15:1) Warning: <table> lacks "summary" attribute
 (32:1) Warning: <table> lacks "summary" attribute
 (40:1) Warning: <table> lacks "summary" attribute
HERE
my @mess = map { $_ ? $_->as_string() : undef } $tidy->messages();
is_deeply( \@mess, \@expected, 'Messages match' );

exit 0;

__DATA__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"><head>
<meta http-equiv="content-type" content="text/html;charset=iso-8859-1" />
<title>TITLEWAVE - Username &amp; Password Assistance</title>
<link href="/css/main-0.css" type="text/css" rel="stylesheet" media="all" />
<script type="text/javascript" src="/javascript/tw-0.js"></script>
<script type="text/javascript" src="/javascript/jquery-0.js"></script>
<script type="text/javascript" src="/javascript/jquery.hoverIntent-0.js"></script>
<script type="text/javascript" src="/javascript/hovering-0.js"></script>
<script type="text/javascript" src="/javascript/jquery.bgiframe-0.js"></script>
</head>
<body >
<div id="header">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
<td>
<a href="/index.html">
<img alt="country-graphic" src="/graphics/hc/titlewave/titlewave.gif"/>
</a>
</td>
<td align="right" valign="top">
<div id="nav">
<a name="_home" href="/index.html">
<img src="/graphics/hc/links/home.gif" alt="Home" />
</a>
</div>
</td>
</tr>
</table><div class="divider-dark"><!-- --></div><div class="divider-light"><!-- --></div></div>
<div id="container">
<table width="100%" border="0" cellspacing="0" cellpadding="5">
<tr>
<td valign="top">
<h1><span class="smallcaps">Titlewave</span> Username &amp; Password Assistance</h1><div class="divider"><!-- --></div><div class="spacer10"><!-- --></div> <form method="post" name="pwd_recover_form" action="/register/recover"><h2>Forgot your username or password?</h2>
<p>
If you have forgotten your <span class="smallcaps">Titlewave</span> username or password, simply enter
the e-mail address you registered with and we will e-mail it to you.
</p><div class="spacer20"><!-- --></div><h2>Please enter your e-mail.</h2>
<table class="form" width="100%" border="0" cellspacing="0" cellpadding="5">
<tr>
<td align="right" nowrap="nowrap" width="150">
<p class="label">E-Mail Address:&nbsp;</p>
</td>
<td>
<input type="text" name="_email" size="35" maxlength="100" value="" />
<input id="_email_go" class="button" type="image" name="_email_go" src="/graphics/hc/buttons/go.gif" />
</td>
</tr>
</table> </form>
</td>
<td valign="top" width="160"><div class="sidebar">
<h2>May We Help You?</h2>
<div class="divider"><!-- --></div>
<div class="content">
<p>We're available to answer any questions you may have about <span class="smallcaps">Titlewave </span> and your orders.</p>
<div class="spacer5"><!-- --></div>
<h4><span class="smallcaps">Titlewave</span> Questions</h4>
<p>Contact our Library Service Consultants Monday through Friday, 7:00 a.m. to 5:00 p.m. Central Time.<br/>
Phone: 888.511.5114 ext. 1164<br/>
E-mail: <a href="mailto:lsc@flr.follett.com">lsc@flr.follett.com</a></p>
<div class="spacer5"><!-- --></div>
<h4>Technical Support</h4>
<p>Contact us Monday through Friday, 7:45 a.m. to 4:15 p.m. Central Time.<br/>
Phone: 888.511.5114 ext. 1513<br/>
E-mail: <a href="mailto:titlewave@flr.follett.com">titlewave@flr.follett.com</a></p>
<div class="spacer5"><!-- --></div>
<h4>Order Questions</h4>
<p>Contact our Customer Care Consultants Monday through Friday, 6:00 a.m. to 7:00 p.m. Central Time.<br/>
Phone: 888.511.5114 ext. 1102<br/>
E-mail: <a href="mailto:customerservice@flr.follett.com">customerservice@flr.follett.com</a></p>
<div class="divider"><!-- --></div>
</div>
</div> </td>
</tr>
</table>
</div>
<div id="footer"><div class="divider"><!-- --></div>
<div id="contact_info">
<p>TITLEWAVE Questions: Contact our Library Service Consultants at
<a href="mailto:lsc@flr.follett.com">lsc@flr.follett.com</a> or 888.511.5114 ext. 1164 or use our <a href="/help" onclick="window.open('/help','ExportHelp',config='width=600,height=450,menubar=1,scrollbars=1'); return false;">Online Help</a><br />
Order Questions: Contact our Customer Care Consultants at <a href="mailto:customerservice@flr.follett.com">customerservice@flr.follett.com</a> or
888.511.5114 ext. 1102 </p>
<p>Copyright &copy; 2010 Follett Library Resources, Inc. -
1340 Ridgeview Drive - McHenry, Illinois 60050<br />
Phone: 888.511.5114 or 815.759.1700 -
Fax: 800.852.5458 or 815.759.9831
</p>
</div>
</div></body></html>
