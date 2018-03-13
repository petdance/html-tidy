#!perl -T

use strict;
use warnings;
use 5.10.1;

use Test::More tests => 1;

use HTML::Tidy;
use HTML::Tidy::Message;

diag( "Testing HTML::Tidy $HTML::Tidy::VERSION, tidy " . HTML::Tidy->tidy_library_version() . ", Perl $], $^X" );
pass( 'Modules loaded' );
