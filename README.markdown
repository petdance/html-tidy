HTML::Tidy
==========
HTML::Tidy is an HTML checker in a handy dandy object.  It's meant as
a replacement for HTML::Lint.


INSTALLING TIDYP
================
You need the tidyp library to build HTML::Tidy.  If you
haven't installed it, you can get a source distribution at
[Github](http://github.com/petdance/tidyp/downloads).

You can also try installing the CPAN module Alien::Tidyp, which
encapsulates the tidyp installation.


INSTALLATION
============
Once you have libtidyp installed, install HTML::Tidy like any standard
Perl module.

    perl Makefile.PL
    make
    make test
    make install


COPYRIGHT AND LICENSE
=====================
Copyright (C) 2004-2010 by Andy Lester

This library is free software.  It may be redistributed and modified
under the Artistic License v2.0.
