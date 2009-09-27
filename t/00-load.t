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
eval {
    # For better test reporting
    diag( "Testing HTML::Tidy $HTML::Tidy::VERSION, Perl $]; tidylib " . HTML::Tidy->libtidy_version());
}
