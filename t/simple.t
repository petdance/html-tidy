#!perl -Tw

use warnings;
use strict;

use Test::More tests => 4;

BEGIN {
    use_ok( 'HTML::Tidy' );
}

my $html = join '', <DATA>;

my $tidy = HTML::Tidy->new;
isa_ok( $tidy, 'HTML::Tidy' );

$tidy->parse( '-', $html );

my @messages = $tidy->messages;
is( scalar @messages, 5, 'Right number of initial messages' );

$tidy->clear_messages;
is( scalar $tidy->messages, 0, 'Cleared the messages' );

__DATA__
<html>
    <body><head>blah blah</head>
        <title>Barf</title>
        <body>
            <p>more blah
            </P>
        </body>
    </html>

