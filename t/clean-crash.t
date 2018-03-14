#!/usr/bin/perl -T

use warnings;
use strict;

# From a bug found by Aaron Patterson
#Full context and any attached attachments can be found at:
#<URL: https://rt.cpan.org/Ticket/Display.html?id=7254 >
#Here's a snippet of code to repro the bug, it produces an 'Illegal instruction' error

use Test::More tests => 2;

use HTML::Tidy;

my $html = do { local $/; <DATA> };

my $tidy = HTML::Tidy->new;
isa_ok( $tidy, 'HTML::Tidy' );
$tidy->ignore( type => TIDY_INFO );
$tidy->clean( $html );

my @mess = map { $_ ? $_->as_string() : undef } $tidy->messages();
pass( 'Ended OK' );

__DATA__
<form action="http://www.alternation.net/cobra/index.pl">
<td><input name="random" type="image" value="random creature" src="http://www.creaturesinmyhead.com/images/random.gif"></td>
</form>
