#!perl -Tw
# unicode.t 
# Copyright (c) 2006 Jonathan Rockway <jrockway@cpan.org>

use warnings;
use strict;
use Test::More tests => 7;

BEGIN {
    use_ok( 'HTML::Tidy' );
}

my $args = { newline => 'Lf' };
my $tidy = HTML::Tidy->new($args);

# suck in the reference HTML document
open( my $html_in, '<:utf8', 't/unicode.html' ) or
    die "Can't read unicode.html: $!";
my $html = do { local $/; <$html_in> };
close $html_in;

# suck in the correct, cleaned doc (from DATA)
binmode DATA, ':utf8';
my $reference = do {local $/; <DATA>};

# make sure both are unicode characters (not utf-x octets)
ok(utf8::is_utf8($html), 'html is utf8');
ok(utf8::is_utf8($reference), 'reference is utf8');

my $clean = $tidy->clean( $html );
ok(utf8::is_utf8($clean), 'cleaned output is also unicode');

$clean =~ s/"HTML Tidy.+w3\.org"/"Tidy"/;
is($clean, $reference, q{Cleanup didn't break anything});

my @messages = $tidy->messages;
is( scalar @messages, 0, q{There shouldn't have been any errors});

$tidy = HTML::Tidy->new($args);
$tidy->parse( '', $html );
@messages = $tidy->messages;
is( scalar @messages, 0, q{There still shouldn't be any errors});

__DATA__
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">
<html>
<head>
<meta name="generator" content="Tidy">
<title>日本語のホムページ</title>
</head>
<body>
<p>Unicodeが好きですか?</p>
</body>
</html>
