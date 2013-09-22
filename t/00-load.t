#!perl -T

use strict;
use warnings;

use Test::More tests => 1;

use HTML::Tidy;
use HTML::Tidy::Message;

diag( "Testing HTML::Tidy $HTML::Tidy::VERSION, Perl $]; tidyp " . HTML::Tidy->tidyp_version() );
pass( 'Modules loaded' );
