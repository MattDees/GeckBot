package GeckBot::Logger::Result::Channel;

use strict;
use warnings;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('channels');

__PACKAGE__->add_columns(
	id => {
		data_type => 'INT',
		size => 32,
		is_nullable => 0,
		is_auto_increment => 1,
	},
	name => {
		data_type => 'VARCHAR',
		size => 32,
		is_nullable => 0,
	},
	network => {
		data_type => 'VARCHAR',
		size => 64,
		is_nullable => 0,
	},
);

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many(
	msg => 'GeckBot::Logger::Result::ChannelMessage', 'channel_id',
);

__PACKAGE__->has_many(
	userevents => 'GeckBot::Logger::Result::ChannelUserEvents', 'channel_id',
);

__PACKAGE__->has_many(
	karma => 'GeckBot::Logger::Result::Karma', 'channel_id',
);

__PACKAGE__->has_many(
	quotes => 'GeckBot::Logger::Result::Quotes', 'channel_id',
);

1;