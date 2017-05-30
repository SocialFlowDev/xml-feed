package XML::Feed::Entry::Format::MRSS;
use strict;
use warnings;

our $VERSION = '0.53';

sub format { 'MRSS' }

use XML::Feed::Content;

use base qw(  XML::Feed::Entry::Format::RSS );

sub media_content {
    my $self = shift;
    return unless ($self->{entry});
    return unless ($self->{entry}{'media:content'});
    if (ref($self->{entry}{'media:content'}) eq 'ARRAY') {
        return {} unless (@{$self->{entry}{'media:content'}});
        return $self->{entry}{'media:content'}[0];
    }

    return unless (ref($self->{entry}{'media:content'}) eq 'HASH');
    return $self->{entry}{'media:content'};
}



1;

