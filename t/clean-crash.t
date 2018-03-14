#!/usr/bin/perl -T

use 5.010001;
use warnings;
use strict;

# From a bug found by Aaron Patterson
#Full context and any attached attachments can be found at:
#<URL: https://rt.cpan.org/Ticket/Display.html?id=7254 >
#Here's a snippet of code to repro the bug, it produces an 'Illegal instruction' error

use Test::More tests => 2;

use HTML::Tidy;

my $html = do { local $/ = undef; <DATA> };

my $tidy = HTML::Tidy->new;
isa_ok( $tidy, 'HTML::Tidy' );
$tidy->ignore( type => TIDY_INFO );
$tidy->clean( $html );

my @expected = split( /\n/, <<'HERE' );
 (1:1) Warning: missing <!DOCTYPE> declaration
 (1:1) Warning: inserting implicit <body>
 (1:1) Warning: missing </form> before <td>
 (2:1) Warning: inserting implicit <table>
 (2:1) Warning: missing <tr>
 (3:1) Error: discarding unexpected </form>
 (2:1) Warning: missing </table>
 (1:1) Warning: missing </form>
 (1:1) Warning: inserting missing 'title' element
HERE
my @mess = map { $_ ? $_->as_string() : undef } $tidy->messages();
is_deeply( \@mess, \@expected, 'Messages match' );

exit 0;

__DATA__
<form action="http://www.alternation.net/cobra/index.pl">
<td><input name="random" type="image" value="random creature" src="http://www.creaturesinmyhead.com/images/random.gif"></td>
</form>
