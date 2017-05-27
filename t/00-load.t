#!perl -T

use strict;
use warnings;

use Test::More tests => 1;

use HTML::Tidy;
use HTML::Tidy::Message;

diag( "Testing HTML::Tidy $HTML::Tidy::VERSION, tidyp " . HTML::Tidy->tidyp_version() . ", Perl $], $^X" );
pass( 'Modules loaded' );
