#!perl -T

use warnings;
use strict;

use Test::More tests => 1;

use HTML::Tidy;

my $tidy = HTML::Tidy->new({
    tidy_mark           => 0,
    add_xml_decl        => 1,
    output_xhtml        => 1,
    doctype             => 'strict',
    clean               => 1,
    css_prefix          => 'myprefix',
    drop_empty_paras    => 0,
    enclose_block_text  => 1,
    escape_cdata        => 1,
    hide_comments       => 1,
    replace_color       => 1,
    repeated_attributes => 'keep-first',
    break_before_br     => 1,
    vertical_space      => 1,
    newline             => 'cr',
});

my $input=<<'EOD';
<h1>example</h1>
Here's some <B>ed and <BR/>eakfest MarkUp: <!-- ... -->
<font color="#0000FF" color="RED">...</font>
<p></P>
EOD

my $expected =<<'EOD';
<?xml version="1.0"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>
</title>
<style type="text/css">
/*<![CDATA[*/
 span.myprefix-1 {color: blue}
/*]]>*/
</style>
</head>
<body>
<h1>example</h1>

<p>Here's some <b>ed and
<br />
eakfest MarkUp: <span class="myprefix-1">...</span></b></p>

<p>
</p>
</body>
</html>
EOD

my @expected = split(/\n/, $expected);

my $result = $tidy->clean( $input );
my @result = split(/\r/, $result);

is_deeply( \@result, \@expected, 'Cleaned stuff looks like what we expected');

