#!/usr/bin/perl -T

use strict;
use warnings;

use Test::Exception;
use Test::More tests => 2;

use HTML::Tidy;

my $tidy = HTML::Tidy->new;
isa_ok( $tidy, 'HTML::Tidy' );

my $expected_pattern = 'Usage: parse($filename,$str [, $str...])';
throws_ok {
    $tidy->parse('fake-filename.txt');
} qr/\Q$expected_pattern\E/,
'parse() dies when not given a string or array of strings to parse';
