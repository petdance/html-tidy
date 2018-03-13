#!/usr/bin/perl -T

use strict;
use warnings;

use Test::Exception;
use Test::More tests => 3;

use HTML::Tidy;

my $tidy = HTML::Tidy->new( { wrap => 0 } );
isa_ok( $tidy, 'HTML::Tidy' );

my $expected_pattern = 'Usage: clean($str [, $str...])';
throws_ok {
    $tidy->clean();
} qr/\Q$expected_pattern\E/,
'clean() croaks when not given a string or list of strings';

like(
    $tidy->clean(''),
    _expected_empty_html(),
    '$tidy->clean("") returns empty HTML document',
);

sub _expected_empty_html {
    return qr{<!DOCTYPE html>
<html>
<head>
<meta name="generator" content="HTML Tidy for HTML5 for Linux version \d+\.\d+\.\d+">
<title></title>
</head>
<body>
</body>
</html>
};
}
