HTML::Tidy
==========
HTML::Tidy is an HTML checker in a handy dandy object.  It's meant as
a companion to [HTML::Lint][1], which is written in Perl but is not
nearly as capable as HTML::Tidy.


PREREQUISITES
=============
HTML::Tidy does very little work.  The real work of HTML::Tidy is done by
the html-tidy library, which is written in C.  To use HTML::Tidy, you must
install html-tidy.  Your package manager probably has it, either as "tidy"
or "html-tidy" or "libtidy".  If there's an option to get a "-devel"
package, get that, too, because Perl needs the header files in it.


INSTALLATION
============
Once you have libtidy installed via one of the previous methods,
install HTML::Tidy like any standard Perl module.

    perl Makefile.PL
    make
    make test
    make install


COPYRIGHT AND LICENSE
=====================
Copyright (C) 2004-2018 by Andy Lester

This library is free software.  It may be redistributed and modified
under the Artistic License v2.0.

  [1]: http://search.cpan.org/dist/HTML-Lint/ "HTML::Lint"
