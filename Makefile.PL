#!/usr/bin/perl

package main;

use 5.008000;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::Liblist;
use Config;

my $libs = '-ltidyp';
my $inc = "-I. -I/usr/include/tidyp -I/usr/local/include/tidyp -I$Config{usrinc}/tidyp";

eval { require Alien::Tidyp; };

if ( !$@ ) {
    print "Gonna use tidyp via Alien::Tidyp\n";
    $libs = Alien::Tidyp->config('LIBS');
    $inc = Alien::Tidyp->config('INC');
}
else {
    print "Alien::Tidyp not found, gonna look for tidyp on your system\n";
    my @vars = ExtUtils::Liblist->ext( '-L/usr/lib -L/usr/local/lib -ltidyp', 0, 1 );
    $libs = $vars[2];

    if ( !$libs ) {
        $libs = '-ltidyp';
        print <<'EOF';

It seems that you don't have libtidyp installed.  HTML::Tidy does no
real work on its own.  It's just a wrapper aound libtidyp.

HTML::Tidy is only tested to work with libtidyp hosted at
http://github.com/petdance/libtidyp.  This is mostly the same as the one
at http://tidy.sourceforge.net/, with some changes, such as adding a
version number so that we can tell what version we're working with.

If you do have libtidyp installed, and I just haven't detected it,
go ahead and try building.  If HTML::Tidy builds and tests correctly,
then please let Andy Lester know at andy@petdance.com so that he can
fix the library detection code.

EOF
    }
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
    INC                 => $inc,

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
