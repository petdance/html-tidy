#!perl -T

use warnings;
use strict;

use Test::More tests => 3;

use HTML::Tidy;

my $args = { newline => 'Lf' };
my $tidy = HTML::Tidy->new($args);
isa_ok( $tidy, 'HTML::Tidy' );
$tidy->ignore( type => TIDY_INFO );

# clean once
$tidy->ignore( text => qr/DOCTYPE/ );
my $html = '<a href="http://www.example.com/"><em>This is a test.</a>';
my $clean = $tidy->clean( $html );

# then verify that it meets tidy's high standards
$tidy = HTML::Tidy->new($args); # reset messages;
$tidy->ignore( type => TIDY_INFO );
$clean = $tidy->clean($clean);
my @messages = $tidy->messages( $clean );

is_deeply( \@messages, [], q{The cleaned stuff shouldn't have any errors} );

$clean =~ s/"(HTML Tidy|tidyp).+w3\.org"/"Tidy"/;

my $expected = do { local $/ = undef; <DATA> };
is( $clean, $expected, 'Cleaned up properly' );

__DATA__
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">
<html>
<head>
<meta name="generator" content="Tidy">
<title></title>
</head>
<body>
<a href="http://www.example.com/"><em>This is a test.</em></a>
</body>
</html>
