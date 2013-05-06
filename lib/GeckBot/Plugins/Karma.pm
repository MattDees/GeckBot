package GeckBot::Plugins::Karma;

use strict;
use warnings;

sub said
{
    my ($self, $said_hr) = @_;
    if ($said_hr->{'body'} =~ /(.+)(\+\+|\-\-)$/) {
        my $key        = $1;
        my $operation  = $2;
        if ( $string =~ /^(?:.+\ ){2,}.+$/ ) {
        # if the string has more than two spaces... 
        	return "Invalid karma key $key";
        }
        my $channel_id = $self->get_channel_id($said_hr->{'channel'});
        my $value      = change_value($self, $operation, $channel_id, $key);
        return "Karma for $key is now " . $value;
    }
    return;
}

sub triggers
{
    return { 'karma' => \&get_karma, };
}

sub get_karma
{
    my ($self, $said_hr) = @_;

    my $key    = $said_hr->{'body'};
    my $result = $self->schema->resultset('Karma')->find(
        {
            'channel_id' => $self->get_channel_id($said_hr->{'channel'}),
            'key'        => $key,
        },
    );
    my $value = defined $result ? $result->value : 0;
    return "$key has $value karma";

}

sub change_value
{
    my ($self, $operation, $channel_id, $key) = @_;
    $key =~ s/^\W*(\w+)\W*$/$1/g;
    my $value;
    my $karma =
      $self->schema->resultset('Channel')->find({ 'id' => $channel_id })
      ->karma->find_or_new({ key => $key });
    if ($operation eq '++') {
        $karma->value($karma->value + 1);
    }
    else {
        $karma->value($karma->value - 1);
    }
    $karma->insert_or_update;
    return $karma->value;
}

1;
