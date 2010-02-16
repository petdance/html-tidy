#!/usr/bin/perl

package main;

use 5.006001;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::Liblist;

my @vars = ExtUtils::Liblist->ext( '-ltidy', 0, 1 );
my $libs = $vars[2];

if ( !$libs ) {
    $libs = '-ltidy';
    print <<'EOF';

It seems that you don't have libtidy installed.  HTML::Tidy does no
real work on its own.  It's just a wrapper aound libtidy.

HTML::Tidy is only tested to work with libtidy hosted at
http://github.com/petdance/libtidy.  This is mostly the same as the one
at http://tidy.sourceforge.net/, with some changes, such as adding a
version number so that we can tell what version we're working with.

If you do have libtidy installed, and I just haven't detected it,
go ahead and try building.  If HTML::Tidy builds and tests correctly,
then please let Andy Lester know at andy@petdance.com so that he can
fix the library detection code.

EOF
}

eval { require LWP::Simple; };

if ( $@ ) {
    print <<'EOF';

NOTE: It seems that you don't have LWP::Simple installed.
      The webtidy program will not be able to retrieve web pages.

EOF
}

WriteMakefile(
    NAME                => 'HTML::Tidy',
    AUTHOR              => 'Andy Lester <andy@petdance.com>',
    VERSION_FROM        => 'lib/HTML/Tidy.pm',
    ABSTRACT_FROM       => 'lib/HTML/Tidy.pm',
    PREREQ_PM           => {
        'Exporter'      => 0,
        'Test::More'    => 0,
        'Test::Builder' => 0,
        'Carp'          => 0,
        'overload'      => 0,
        'constant'      => 0,
    },

    LIBS                => [$libs],
    NEEDS_LINKING       => 1,
    INC                 => '-I. -I/usr/include/tidy -I/usr/local/include/tidy -I/sw/include/tidy',

    EXE_FILES           => [qw(bin/webtidy)],
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'HTML-Tidy-*' },
);


sub MY::postamble {
return <<'MAKE_FRAG';
.PHONY: tags critic

tags:
	ctags -f tags --recurse --totals \
		--exclude=blib --exclude=t/lib \
		--exclude=.svn --exclude='*~' \
		--languages=C,Perl --langmap=Perl:+.t \
		.

critic:
	perlcritic -1 \
		-profile perlcriticrc \
		.

MAKE_FRAG
}
