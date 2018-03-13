#!perl -T

use 5.010001;
use strict;
use warnings;

use Test::More tests => 1;

use HTML::Tidy;
use HTML::Tidy::Message;

diag( "Testing HTML::Tidy $HTML::Tidy::VERSION, tidy " . HTML::Tidy->tidy_library_version() . ", Perl $], $^X" );
pass( 'Modules loaded' );
