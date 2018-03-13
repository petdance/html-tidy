#!perl -T

use warnings;
use strict;

use Test::More tests => 4;

use HTML::Tidy;

my $html = join '', <DATA>;

my $tidy = HTML::Tidy->new;
isa_ok( $tidy, 'HTML::Tidy' );

$tidy->ignore( type => TIDY_INFO );
my $rc = $tidy->parse( '-', $html );
ok( $rc, 'Parsed OK' );

my @messages = $tidy->messages;
is( scalar @messages, 6, 'Right number of initial messages' );

$tidy->clear_messages;
is_deeply( [$tidy->messages], [], 'Cleared the messages' );

__DATA__
<html>
    <body><head>blah blah</head>
        <title>Barf</title>
        <body>
            <p>more blah
            </P>
        </body>
    </html>

