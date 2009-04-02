#!perl -Tw

use warnings;
use strict;

use Test::More tests => 16;

BEGIN { use_ok( 'HTML::Tidy' ); }
BEGIN { use_ok( 'HTML::Tidy::Message' ); }

WITH_LINE_NUMBERS: {
    my $error = HTML::Tidy::Message->new( 'foo.pl', TIDY_ERROR, 2112, 5150, 'Blah blah' );
    isa_ok( $error, 'HTML::Tidy::Message' );

    my %expected = (
        file        => 'foo.pl',
        type        => TIDY_ERROR,
        line        => 2112,
        column      => 5150,
        text        => 'Blah blah',
        as_string   => 'foo.pl (2112:5150) Error: Blah blah',
    );
    _match_up( $error, %expected );
}

WITHOUT_LINE_NUMBERS: {
    my $error = HTML::Tidy::Message->new( 'bar.pl', TIDY_WARNING, undef, undef, 'Blah blah' );
    isa_ok( $error, 'HTML::Tidy::Message' );

    my %expected = (
        file        => 'bar.pl',
        type        => TIDY_WARNING,
        line        => 0,
        column      => 0,
        text        => 'Blah blah',
        as_string   => 'bar.pl - Warning: Blah blah',
    );
    _match_up( $error, %expected );
}

sub _match_up {
    my $error = shift;
    my %expected = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;
    for my $what ( sort keys %expected ) {
        is( $error->$what, $expected{$what}, "$what matches" );
    }
}
