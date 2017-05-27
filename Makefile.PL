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
    print "Using tidyp via Alien::Tidyp\n";
    $libs = Alien::Tidyp->config('LIBS');
    $inc = Alien::Tidyp->config('INC');
}
else {
    print "Alien::Tidyp not found. Looking for for tidyp on your system.\n";
    my @vars = ExtUtils::Liblist->ext( '-L/usr/lib -L/usr/local/lib -ltidyp', 0, 1 );
    $libs = $vars[2];

    if ( !$libs ) {
        $libs = '-ltidyp';
        print <<'EOF';

It seems that you don't have tidyp installed.  HTML::Tidy does no
real work on its own.  It's just a wrapper around tidyp.

Please read the README.markdown file for details on how to install tidyp.

If you do have tidyp installed, but Makefile.PL can't detect it,
go ahead and try building.  If HTML::Tidy builds and tests correctly,
please file a ticket at Github at
http://github.com/petdance/html-tidy/issues, so we can fix the
library detection code.

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

my $parms = {
    NAME                => 'HTML::Tidy',
    AUTHOR              => 'Andy Lester <andy@petdance.com>',
    VERSION_FROM        => 'lib/HTML/Tidy.pm',
    ABSTRACT_FROM       => 'lib/HTML/Tidy.pm',
    PREREQ_PM           => {
        'Encode'        => 0,   # for tests
        'Exporter'      => 0,
        'Getopt::Long'  => 0,   # in webtidy
        'Test::More'    => '0.98', # For subtest()
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
};

if ( $ExtUtils::MakeMaker::VERSION ge '6.45_01' ) {
    $parms->{META_MERGE} = {
        resources => {
            license     => 'http://www.opensource.org/licenses/artistic-license-2.0.php',
            homepage    => 'http://github.com/petdance/html-tidy',
            bugtracker  => 'http://github.com/petdance/html-tidy/issues',
            repository  => 'http://github.com/petdance/html-tidy',
        }
    };
    $parms->{LICENSE} = 'artistic_2';
}
if ( $ExtUtils::MakeMaker::VERSION ge '6.47_02' ) {
    $parms->{MIN_PERL_VERSION} = 5.008;
}

WriteMakefile( %{$parms} );

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
