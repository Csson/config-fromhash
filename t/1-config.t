use strict;
use warnings;

use FindBin;
use Test::More;
use Test::Deep;
use Test::Exception;
use Config::FromHash;

my $hash_config = {
	habit => 'escalator',
	aim   => 'silence',
	condo => 'doomsday',
	sphere => 'shine',
	barren => 'village',
	headphones => [qw/odd gibberish artist/],
	king => { 
		badmouth => {
			selfish => 'again',
			vacant => 'angel',
		},
		estate => 'marginal',
		military => 2,
	},
};

my $conf => Config::FromHash->new(data => $hash_config);

isa_ok $conf, 'Config::FromHash';

is_deeply $conf->data => $data;


done_testing;
