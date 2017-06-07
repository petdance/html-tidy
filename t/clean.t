#!/usr/bin/perl -T

use strict;
use warnings;

use Test::Exception;
use Test::More tests => 3;

use HTML::Tidy;

my $tidy = HTML::Tidy->new;
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
    return qr{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 3.2//EN">
<html>
<head>
<meta name="generator" content="[^"]+">
<title></title>
</head>
<body>
</body>
</html>
};
}
