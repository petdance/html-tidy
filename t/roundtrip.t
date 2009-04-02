#!perl -Tw

use warnings;
use strict;
use Test::More tests => 4;

BEGIN {
    use_ok( 'HTML::Tidy' );
}

my $args = { newline => 'Lf' };
my $tidy = HTML::Tidy->new($args);
isa_ok( $tidy, 'HTML::Tidy' );

# clean once
$tidy->ignore( text => qr/DOCTYPE/ );
my $html = '<a href="http://www.example.com/"><em>This is a test.</a>';
my $clean = $tidy->clean( $html );

# then verify that it meets tidy's high standards
$tidy = HTML::Tidy->new($args); # reset messages;
$clean = $tidy->clean($clean);
my @messages = $tidy->messages( $clean );

is( scalar @messages, 0, q{The cleaned stuff shouldn't have any errors} );
diag( 'But they do...', Dumper(\@messages) ) if @messages;

$clean =~ s/"HTML Tidy.+w3\.org"/"Tidy"/;

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
