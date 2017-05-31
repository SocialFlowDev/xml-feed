package XML::Feed::Entry::Format::MRSS;
use strict;
use warnings;
use List::Util qw(first);

our $VERSION = '0.53';

sub format { 'MRSS' }

use XML::Feed::Content;

use base qw(  XML::Feed::Entry::Format::RSS );

sub media_content {
    my ( $self, $type ) = @_;
    return unless ( $self->{entry} );
    return unless ( $self->{entry}{'media:content'} );
    if ( ref( $self->{entry}{'media:content'} ) eq 'ARRAY' ) {
        return {} unless ( @{ $self->{entry}{'media:content'} } );
        if ($type) {
            return first { $_->{'-medium'} eq $type }
            @{ $self->{entry}{'media:content'} };
        }
        return $self->{entry}{'media:content'}[0];
    }

    return unless ( ref( $self->{entry}{'media:content'} ) eq 'HASH' );


    if ($type) {
        return
          unless ( $self->{entry}{'media:content'}{'-medium'}
            && $self->{entry}{'media:content'}{'-medium'} eq $type );
    }
    return $self->{entry}{'media:content'};
}



1;

