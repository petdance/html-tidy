package HTML::Tidy::Message;

use warnings;
use strict;
use overload
    q{""} => \&as_string,
    fallback => 'sounds like a good idea';

=head1 NAME

HTML::Tidy::Message - Message object for the Tidy functionality

=head1 SYNOPSIS

See L<HTML::Tidy|HTML::Tidy> for all the gory details.

=head1 EXPORTS

None.  It's all object-based.

=head1 METHODS

Almost everything is an accessor.

=head2 new( $file, $line, $column, $text )

Create an object.  It's not very exciting.

=cut

sub new {
    my $class  = shift;

    my $file   = shift;
    my $type   = shift;
    my $line   = shift || 0;
    my $column = shift || 0;
    my $text   = shift;

    # Add an element that says what tag caused the error (B, TR, etc)
    # so that we can match 'em up down the road.
    my $self  = {
        _file   => $file,
        _type   => $type,
        _line   => $line,
        _column => $column,
        _text   => $text,
    };

    bless $self, $class;

    return $self;
}

=head2 where()

Returns a formatted string that describes where in the file the
error has occurred.

For example,

    (14:23)

for line 14, column 23.

The terrible thing about this function is that it's both a plain
ol' formatting function as in

    my $str = where( 14, 23 );

AND it's an object method, as in:

    my $str = $error->where();

I don't know what I was thinking when I set it up this way, but
it's bad practice.

=cut

sub where {
    my $self = shift;

    return '-' unless $self->line && $self->column;

    return sprintf( '(%d:%d)', $self->line, $self->column );
}

=head2 as_string()

Returns a nicely-formatted string for printing out to stdout or some similar user thing.

=cut

sub as_string {
    my $self = shift;

    my %strings = (
        1 => 'Info',
        2 => 'Warning',
        3 => 'Error',
    );

    return sprintf( '%s %s %s: %s',
        $self->file, $self->where, $strings{$self->type}, $self->text );
}

=head2 file()

Returns the filename of the error, as set by the caller.

=head2 type()

Returns the type of the error.  This will either be C<TIDY_ERROR>,
or C<TIDY_WARNING>.

=head2 line()

Returns the line number of the error, or 0 if there isn't an applicable
line number.

=head2 column()

Returns the column number, or 0 if there isn't an applicable column
number.

=head2 text()

Returns the text of the message.  This does not include a type string,
like "Info: ".

=cut

sub file    { my $self = shift; return $self->{_file} }
sub type    { my $self = shift; return $self->{_type} }
sub line    { my $self = shift; return $self->{_line} }
sub column  { my $self = shift; return $self->{_column} }
sub text    { my $self = shift; return $self->{_text} }


=head1 COPYRIGHT & LICENSE

Copyright 2005-2017 Andy Lester.

This program is free software; you can redistribute it and/or modify
it under the terms of the Artistic License v2.0.

=head1 AUTHOR

Andy Lester, C<< <andy@petdance.com> >>

=cut

1; # happy
