package XML::Feed::Format::MRSS;

use strict;
use warnings;

use base qw( XML::Feed::Format::RSS );

use XML::Feed::Entry::Format::MRSS;

use XML::FeedPP;

use Try::Tiny;

sub format { 'MRSS' }

sub is_mrss_feed {
    my $class   = shift;
    my $xml     = shift;

    my $is_mrss = 0;

    try {
        my $feed = XML::FeedPP->new( $$xml );
        if ( index($$xml, "xmlns:media=\"http://search.yahoo.com/mrss/\"" ) < 0 ) {
            $is_mrss = 0;
        }
        foreach my $item ( $feed->get_item() ) {
            if ( $item->{'media:content'}
                 && ref $item->{'media:content'} eq 'HASH'
                 && $item->{'media:content'}->{'-url'}  )  {
                 $is_mrss = 1;
                 last
            }
        }
    } catch {
        $is_mrss = 0;
    };

    return $is_mrss;
}


sub init_string {
    my $feed = shift;
    my($str) = @_;
    #Create XML::Feed object using both XML::Feed->parse and equivalent method in FeedPP
    #Channel fields populated by XML::Feed output.
    #Item fields populated by FeedPP output ( handles media:* fields )

    my $feedpp_output = XML::FeedPP->new( $$str );
    $feed->init_empty;

    # Title is the only thing toplevel that i can think of -joe
    $feed->title($feedpp_output->title);


    for my $feedpp_item ($feedpp_output->get_item() ) {
        my $guid = $feedpp_item->{guid}->{'#text' };
        $feedpp_item->{guid} = $guid; # replace guid hash created by FeedPP with just guid string
        $feed->{rss}->add_item(%$feedpp_item);
    }
    return $feed

}


sub entries {
    my $rss = $_[0]->{rss};
    my @entries;
    for my $item (@{ $rss->{items} }) {
        push @entries, XML::Feed::Entry::Format::MRSS->wrap($item);
    }
    @entries;
}

1;
