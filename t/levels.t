#!perl -Tw

use warnings;
use strict;
use Test::More tests => 3;

BEGIN {
    use_ok( 'HTML::Tidy' );
}

my $tidy = new HTML::Tidy;
isa_ok( $tidy, 'HTML::Tidy' );
$tidy->parse( '-', <DATA> );

my @expected = split /\n/, q{
- (1:1) Warning: missing <!DOCTYPE> declaration
- (23:1) Error: <bogotag> is not recognized!
- (23:1) Warning: discarding unexpected <bogotag>
- (24:XX) Warning: unescaped & which should be written as &amp;
- (24:XX) Warning: unescaped & which should be written as &amp;
};
chomp @expected;
shift @expected; # First one's blank

my @messages = map { $_->as_string } $tidy->messages;
s/[\r\n]+\z// for @messages;
munge_returned( \@messages );
is_deeply( \@messages, \@expected, 'Matching messages' );

sub munge_returned {
    # non-1 line numbers are not reliable across libtidies
    my $returned = shift;
    my $start_line = shift || qq{-};
    for ( my $i = 0; $i < scalar @{$returned}; $i++ ) {
        next if $returned->[$i] =~ m/$start_line \(\d+:1\)/;
        $returned->[$i] =~ s/$start_line \((\d+):(\d+)\)/$start_line ($1:XX)/;
    }
}

__DATA__
<HTML>
<HEAD>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html;CHARSET=iso-8859-1">
	<META NAME="Author" Content="Andy Lester">
    	<TITLE>petdance.com: Andy Lester's Programming &amp; Writing</TITLE>

<STYLE type="text/css">
<!--
DIV.TOC H2 {
    font-family : tahoma, arial, helvetica, sans-serif;
    font-weight : bold;
    font-size : 15pt;
    }

DIV.TOC P {
    font-size : 12pt;
    font-weight : normal;
    }
-->
</STYLE>
</HEAD>
<BODY BGCOLOR="white">
<BOGOTAG>
    <IMG SRC="/pix/petdance-logo-400x312.gif" HEIGHT=312 WIDTH=400 ALT="Andy & Amy's Pet Supplies & Dance Instruction" ALIGN=RIGHT>
	<DIV CLASS="TOC">
	<h2>Perl, Programming &amp; Writing</h2>
	My <A HREF="http://www.oreillynet.com/pub/au/1249">Technology &amp; publishing blog</A> at oreillynet.com<BR>
	My <A HREF="http://use.perl.org/~petdance/journal/">Perl-specific and personal blog</A> at use.perl.org<BR>
	<A HREF="resume/">Andy Lester's resume</A><BR>
	Andy's <A HREF="perl/">Perl Pages</A>

	<H2>The Lester Family</h2>
	<A HREF="/andy/">Andy</A>: The Dad<BR>
	<A HREF="http://www.parsley.org/">Amy</A>: The Mom<BR>
	<A HREF="http://www.parsley.org/quinn/">Quinn</A>: The Girl<BR>
	<A HREF="/baxter/">Baxter</A>: The Dog<BR>
	<A HREF="http://www.familytreemaker.com/users/l/e/s/Andrew-R-Lester/">Our family trees</A>

	<H2>About Andy &amp; Amy</H2>
    	<A HREF="/us/mush/">The Page Of Mush</A><BR>
	<A HREF="/us/people/">People we're looking for</A><BR>
    	<A HREF="/us/herald/">Article about us and how we met</A> from the Northwest Herald<BR>

	<H2>Useful Stuff</H2>
	<A HREF="/start/">Andy's Magic Start Page</A>: Bunches of your favorite search engines, all in one place<BR>
	<A HREF="/adds/">Add-a-page Page</A>: Bunches of website submission forms, all in one place<BR>
	<A HREF="cf/">Cold Fusion stuff</A>: CFX_HTTP and other custom tags

	<H2>Musical Information, etc</H2>
    	<A HREF="/nr/">Naked Raygun</A>: Bring your mom and your mom's friends, too<BR>
	<A HREF="/actionpark/">Action Park</A>: A compendium of information about Big Black, Rapeman, Shellac and Steve Albini<BR>

	<H2>Other things that might be fun</h2>
    	<A HREF="http://www.parsley.org/"><CITE>When In Doubt, Use Parsley</CITE></A>: Amy's journal<BR>
	<A HREF="/wonder/"><CITE>Wonder</CITE></A>: Andy's old journal<BR>
    	<A HREF="/us/trip/">So American It Hurts</A>: Andy &amp; Amy's trip to Graceland<BR>
    	<A HREF="/andy/appliances/">Gallery Of Household Appliances</A><BR>
	<A HREF="/wants/">Media Wants</A>: Stuff I yearn to consume<BR>
	<A HREF="/andy/bingo/">Buzzword Bingo</A>

	</DIV>

</BODY>
</HTML>
