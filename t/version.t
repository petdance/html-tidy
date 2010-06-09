#!perl -Tw

use warnings;
use strict;
use Test::More;

BEGIN {
    plan tests => 5;
    use_ok( 'HTML::Tidy' );
}

for my $version_string (HTML::Tidy->tidyp_version, HTML::Tidy->libtidyp_version) {
    like( $version_string, qr/^\d\.\d{2,}$/, 'Valid version string' );
    cmp_ok( $version_string, '>=', '0.90', 'Version is greater than 0.90, which is the one I maintain' );
}

