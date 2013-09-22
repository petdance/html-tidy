#!perl -T

use warnings;
use strict;

use Test::More tests => 2;

use HTML::Tidy;

my $filename = 't/venus.html';
open( my $fh, '<', $filename ) or die "Can't open $filename: $!\n";
my $raw = do { local $/ = undef; <$fh> };
close $fh;

my $cfg = 't/venus.cfg';
my $tidy = HTML::Tidy->new( {config_file => $cfg} );
isa_ok( $tidy, 'HTML::Tidy' );

my $cooked = $tidy->clean( $raw );
my @cooked = split( /\n/, $cooked );
chomp @cooked;

my @expected = <DATA>;
chomp @expected;
is_deeply( \@cooked, \@expected, 'Cooked stuff looks like what we expected' );

__DATA__
<html>
  <head>
    <meta name="GENERATOR" content="Adobe PageMill 3.0 Mac" />
    <title>Venus Flytrap for 100 Question</title>
  </head>
  <body bgcolor="#FFFFFF" link="#5B3D23" alink="#8C6136" vlink="#BE844A" background="../../WetlandGraphics/PaperBG.gif">
    <center>
      <h1>
        <img src="../../WetlandGraphics/KildeerLogo2.gif" width="345" height="21" align="bottom" border="0" />
      </h1>
    </center>
    <center>
      <h1>Wetland Plants Jeopardy</h1>
    </center>
    <center>
      <h1>
        <font color="#ED181E">Venus Flytrap for 100</font>
      </h1>
    </center>
    <center>
      <h1>
        <img src="ST100.gif" width="100" height="101" align="bottom" />
      </h1>
    </center>
    <p> </p>
    <center>
      <h2>
      <font color="#ED181E">Question:</font> What does the Venus Flytrap feed on?</h2>
    </center>
    <center>
      <h4>
        <a href="Venus100Ans.html">Click here for the answer.</a>
      </h4>
    </center>
    <center>
      <h4>
        <img src="../../WetlandGraphics/GoldbarThread.gif" width="648" height="4" align="bottom" />
      </h4>
    </center>
    <center>
      <h4>| 
      <a href="../../General/Map.html">Map</a> | 
      <a href="../../General/SiteSearch.html">Site Search</a> | 
      <a href="../../General/Terms.html">Terms</a> | 
      <a href="../../General/Credits.html">Credits</a> | 
      <a href="../../General/Feedback.html">Feedback</a> |</h4>
    </center>
    <center>
      <p>
        <img src="../../WetlandGraphics/GoldbarThread.gif" width="648" height="4" align="bottom" />
      </p>
    </center>
    <div align="center"></div>
    <center>
      <address>Created for the Museums in the Classroom program sponsored by Illinois State Board of Education, the Brookfield Zoo, the Illinois State Museum., and Kildeer Countryside CCSD 96.</address>
      <address> </address>
      <address>Authors: Twin Groves Museums in the Classroom Team,</address>
      <address>School: Twin Groves Junior High School, Buffalo Grove, Illinois 60089</address>
    </center>
    <center>Created: 27 June 1998- Updated: 6 October 2003</center>
  </body>
</html>
