#!perl -Tw

use strict;
use warnings;
use Test::More tests => 2;

BEGIN {
    use_ok( 'HTML::Tidy' );
}
BEGIN {
    use_ok( 'HTML::Tidy::Message' );
}
