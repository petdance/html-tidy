#!perl -T

use 5.010001;
use warnings;
use strict;

use Test::More tests => 1;

use HTML::Tidy;

my $version_string = HTML::Tidy->tidy_library_version;
like( $version_string, qr/^5.\d+\.\d+$/, 'Valid version string' );

exit 0;
