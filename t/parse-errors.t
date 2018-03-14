#!/usr/bin/perl -T

use 5.010001;
use strict;
use warnings;

use Test::Exception;
use Test::More tests => 4;

use HTML::Tidy;

my $tidy = HTML::Tidy->new;

my $errbuf = join( '', <DATA> );

CATCH_A_WARNING: {
    my $stashed_warning;
    my $ncalls = 0;
    local $SIG{__WARN__} = sub { $stashed_warning = shift; ++$ncalls; };

    my $ret = $tidy->_parse_errors('fake_filename.html', $errbuf, "\n");
    is( $ret, 1, 'encountered 1 parsing error' );
    is( scalar @{$tidy->{messages}},  7, 'got 7 messages when parsing errors' );

    # Check our warnings.
    is( $ncalls, 1, 'Warning should have been called exactly once' );
    like( $stashed_warning, qr/HTML::Tidy: Unknown error type: FAKE_ERROR_TYPE at/, 'Expected warning' );
}

__DATA__
line 1 column 1 - Warning: missing <!DOCTYPE> declaration
line 1 column 1 - Warning: plain text isn\'t allowed in <head> elements
line 1 column 1 - Info: <head> previously mentioned
line 1 column 1 - Warning: inserting implicit <body>
line 1 column 13 - Warning: missing </b>
line 1 column 1 - Warning: inserting missing \'title\' element
Info: Document content looks like HTML 3.2

FAKE_ERROR_TYPE
Tidy found 5 warnings and 0 errors!
