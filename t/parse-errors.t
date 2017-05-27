#!/usr/bin/perl -T

use strict;
use warnings;

use Test::Exception;
use Test::More tests => 2;

use HTML::Tidy;

my $tidy = HTML::Tidy->new;

my $errbuf = do {
    local $/;
    readline(*DATA);
};

my $ret = $tidy->_parse_errors('fake_filename.html', $errbuf, "\n");
is( $ret, 1, 'encountered 1 parsing error' );
is( scalar @{$tidy->{messages}},  7, 'got 7 messages when parsing errors' );

__DATA__
line 1 column 1 - Warning: missing <!DOCTYPE> declaration
line 1 column 1 - Warning: plain text isn\'t allowed in <head> elements
line 1 column 1 - Info: <head> previously mentioned
line 1 column 1 - Warning: inserting implicit <body>
line 1 column 13 - Warning: missing </b>
line 1 column 1 - Warning: inserting missing \'title\' element
Info: Document content looks like HTML 3.2

FAKE_ERROR_TYPE
5 warnings, 0 errors were found!

