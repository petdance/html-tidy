#!perl -T
# Copyright (c) 2006 Jonathan Rockway <jrockway@cpan.org>

use warnings;
use strict;

use Test::More tests => 9;

use HTML::Tidy;
use Encode ();
use Carp;

my $args = { newline => 'Lf' };
my $tidy = HTML::Tidy->new($args);
$tidy->ignore( type => TIDY_INFO );

# Suck in the reference HTML document.
open( my $html_in, '<:utf8', 't/unicode.html' ) or Carp::croak( "Can't read unicode.html: $!" );
my $html = do { local $/; <$html_in> };
close $html_in;

# Suck in the correct, cleaned doc (from DATA)
binmode DATA, ':utf8';
my $reference = do {local $/; <DATA>};

# Make sure both are unicode characters (not utf-x octets).
ok(utf8::is_utf8($html), 'html is utf8');
ok(utf8::is_utf8($reference), 'reference is utf8');

my $clean = $tidy->clean( $html );
ok(utf8::is_utf8($clean), 'cleaned output is also unicode');

$clean =~ s/"HTML Tidy.+w3\.org"/"Tidy"/;
$clean =~ s/"(HTML Tidy|tidyp).+w3\.org"/"Tidy"/;
is($clean, $reference, q{Cleanup didn't break anything});

my @messages = $tidy->messages;
is_deeply( \@messages, [], q{There still shouldn't be any errors} );

$tidy = HTML::Tidy->new($args);
isa_ok( $tidy, 'HTML::Tidy' );
my $rc = $tidy->parse( '', $html );
ok( $rc, 'Parsed OK' );
@messages = $tidy->messages;
is_deeply( \@messages, [], q{There still shouldn't be any errors} );

subtest 'Try send bytes to clean method.' => sub {
    my $html = Encode::encode('utf8',$html);
    ok(!utf8::is_utf8($html), 'html is row bytes');
    my $clean = $tidy->clean( $html );
    ok(utf8::is_utf8($clean), 'but cleaned output is string');
    $clean =~ s/"HTML Tidy.+w3\.org"/"Tidy"/;
    $clean =~ s/"(HTML Tidy|tidyp).+w3\.org"/"Tidy"/;
    is($clean, $reference, q{Cleanup didn't break anything});
};

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
