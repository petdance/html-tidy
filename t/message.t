#!perl -T

use warnings;
use strict;

use Test::More tests => 4;

use HTML::Tidy;
use HTML::Tidy::Message;

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
    _match_up( $error, \%expected, 'With line numbers' );
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
    _match_up( $error, \%expected, 'Without line numbers' );
}

sub _match_up {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $error    = shift;
    my $expected = shift;
    my $msg      = shift or die;

    return subtest "_matchup( $msg )" => sub {
        plan tests => scalar keys %{$expected};

        for my $what ( sort keys %{$expected} ) {
            is( $error->$what, $expected->{$what}, "$what matches" );
        }
    };
}
