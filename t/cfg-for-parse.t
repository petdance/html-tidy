#!perl -T

use 5.010001;
use warnings;
use strict;

use Test::More tests => 3;

use HTML::Tidy;

my $html = do { local $/ = undef; <DATA> };

my @expected_messages = split /\n/, <<'HERE';
DATA (7:1) Error: <x> is not recognized!
DATA (8:1) Error: <y> is not recognized!
HERE

chomp @expected_messages;

my $tidy = HTML::Tidy->new( { config_file => 't/cfg-for-parse.cfg' } );
isa_ok( $tidy, 'HTML::Tidy' );

my $rc = $tidy->parse( 'DATA', $html );
ok( $rc, 'Parsed OK' );

my @returned = map { $_->as_string } $tidy->messages;
s/[\r\n]+\z// for @returned;
is_deeply( \@returned, \@expected_messages, 'Matching errors' );


__DATA__
<HTML>
<HEAD>
<TITLE>Foo
</HEAD>
<BODY>
</B>
<X>
<Y>
</I>
</BODY>
