HTML::Tidy
==========
HTML::Tidy is an HTML checker in a handy dandy object.  It's meant as
a replacement for [HTML::Lint] [1], which is written in Perl but is not
nearly as capable as HTML::Tidy.


PREREQUISITES
=============
HTML::Tidy does very little work.  The real work of HTML::Tidy is
done by the tidyp library, which is written in C.  To use HTML::Tidy,
you must install tidyp.

There are two, perhaps three, ways to install tidyp:

* Get a tarball from the [tidyp source distributions] [2] from
Github and and build it like any other C library.  Note that you
must get a source tarball, *not* just clone the source tree via
github.

* Install the [Alien::Tidyp] [3] Perl module, which automates the
tidyp installation process.

* Your operating system may also have a package for tidyp that you
can install.  I am not aware of any packages at this writing, but
they could still exist without me knowing.

You need only do one of these steps.


INSTALLATION
============
Once you have libtidyp installed via one of the previous methods,
install HTML::Tidy like any standard Perl module.

    perl Makefile.PL
    make
    make test
    make install


COPYRIGHT AND LICENSE
=====================
Copyright (C) 2004-2010 by Andy Lester

This library is free software.  It may be redistributed and modified
under the Artistic License v2.0.

  [1]: http://search.cpan.org/dist/HTML-Lint/       "HTML::Lint"
  [2]: http://github.com/petdance/tidyp/downloads   "tidyp source distributions"
  [3]: http://search.cpan.org/dist/Alien-Tidyp/     "Alien::Tidyp"
