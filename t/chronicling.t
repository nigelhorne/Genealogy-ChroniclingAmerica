#!perl -T

use strict;
use warnings;
use Test::Most;
use Test::URI;

CHRONICLING: {
	unless(-e 't/online.enabled') {
		plan skip_all => 'On-line tests disabled';
	} else {
		plan tests => 6;

		use_ok('Genealogy::ChroniclingAmerica');

		my $f = Genealogy::ChroniclingAmerica->new({
			'firstname' => 'ralph',
			'lastname' => 'bixler',
			'date_of_birth' => 1912,
			'state' => 'Indiana',
		});
		ok(defined $f);
		ok($f->isa('Genealogy::ChroniclingAmerica'));

		my $count = 0;
		while(my $link = $f->get_next_entry()) {
			diag($link);
			uri_host_ok($link, 'chroniclingamerica.loc.gov');
			$count++;
		}
		ok(!defined($f->get_next_entry()));
		ok($count > 0);
	}
}
