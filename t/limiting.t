#!/usr/bin/env perl

# Test rate limiting

use strict;
use warnings;
use Time::HiRes qw(time);
use Test::Most tests => 4;

BEGIN { use_ok('Genealogy::ChroniclingAmerica') }

# --- Create a custom LWP::UserAgent for testing ---
{
	package MyTestUA;
	use parent 'LWP::UserAgent';
	use HTTP::Response;

	# Global variables to count requests and record request times
	our $REQUEST_COUNT = 0;
	our @REQUEST_TIMES;

	sub get {
		my ($self, $url) = @_;
		push @REQUEST_TIMES, time();
		$REQUEST_COUNT++;

		# Return a dummy successful JSON response. The JSON is a simplified
		# version of what the Chronilcling America API might return.
		# my $content = '{"totalItems": "1", "ocr_eng": "A piece of text about Ralph Bixler", "url": "https://example.com", "itemsPerPage": "20", "items": [{"sequence": 12}]}';
		# return HTTP::Response->new(200, 'OK', [], $content);
		return $self->SUPER::get($url);
	}
}

# Set a short minimum interval for testing purposes (e.g. 1 second)
# But don't test for less than a second without changing the test timer to track microseconds
my $min_interval = 1;

# Create our custom user agent
my $ua = MyTestUA->new();

# Instantiate with our custom UA and min_interval
my $ca = Genealogy::ChroniclingAmerica->new(
	'firstname' => 'ralph',
	'lastname' => 'bixler',
	'date_of_birth' => 1912,
	'state' => 'Indiana',
	min_interval => $min_interval,
	ua => $ua,
);

while(my $link = $ca->get_next_entry()) {
}

# Verify that the rate limiting was enforced by comparing the timestamps of
# the two API calls. There should now be two entries in @MyTestUA::REQUEST_TIMES.
my $num_requests = scalar @MyTestUA::REQUEST_TIMES;
ok($num_requests >= 2, 'At least two API requests have been made');
cmp_ok($num_requests, '==', $MyTestUA::REQUEST_COUNT);

if($num_requests >= 2) {
	my $elapsed = $MyTestUA::REQUEST_TIMES[1] - $MyTestUA::REQUEST_TIMES[0];
	cmp_ok($elapsed, '>=', $min_interval, "Rate limiting enforced: elapsed time >= $min_interval sec");
}
