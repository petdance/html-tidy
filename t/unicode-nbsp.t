#!perl -T

use 5.010001;
use warnings;
use strict;

use Test::More tests => 3;

use HTML::Tidy;

use Encode;

# UTF8 nbsp
my $bytes_string = "\x{c2}\x{a0}"; ## no critic ( ValuesAndExpressions::ProhibitEscapedCharacter )
my $perl_chars   = Encode::decode('utf8',$bytes_string); # Perl chars of utf8 byte string

my $tidy = HTML::Tidy->new({ show_body_only => 1 });

my $newline = $tidy->clean( '' ); # HTML::Tidy adds a platform-dependent "newline".
like( $newline, qr/^\r?\n?$/, 'Tidy Newline' ); # should be CR or LF or both

my $expected_after_tidy = "&nbsp;$newline"; # HTML::Tidy should convert the nbsp to an HTML entity (and add a newline).

is( $tidy->clean( $perl_chars ), $expected_after_tidy, 'Perl chars OK' );
is( $tidy->clean( $bytes_string ), $expected_after_tidy, 'Byte string OK' );

exit 0;
