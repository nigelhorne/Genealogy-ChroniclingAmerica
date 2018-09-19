#!perl -w

use strict;

use lib 'lib';
use Test::Most;
use Genealogy::ChroniclingAmerica;

NEW: {
	if(-e 't/online.enabled') {
		plan tests => 1;

		my $args = {
			'firstname' => 'ralph',
			'lastname' => 'bixler',
			'date_of_birth' => 1912,
			'state' => 'Indiana',
		};

		isa_ok(Genealogy::ChroniclingAmerica->new($args), 'Genealogy::ChroniclingAmerica', 'Creating Genealogy::ChroniclingAmerica object');
	} else {
		plan(skip_all => 'On-line tests disabled');
	}
}
