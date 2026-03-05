# Generated from Makefile.PL using makefilepl2cpanfile

requires 'perl', '5.6.2';

requires 'CHI';
requires 'Carp';
requires 'ExtUtils::MakeMaker', '6.64';
requires 'JSON::MaybeXS';
requires 'LWP::Protocol::https';
requires 'LWP::UserAgent';
requires 'Object::Configure';
requires 'Params::Get', '0.13';
requires 'Return::Set';
requires 'Scalar::Util';
requires 'URI';

on 'configure' => sub {
	requires 'ExtUtils::MakeMaker', '6.64';
};
on 'test' => sub {
	requires 'Test::DescribeMe';
	requires 'Test::HTTPStatus';
	requires 'Test::Kwalitee';
	requires 'Test::MockObject';
	requires 'Test::Most';
	requires 'Test::Needs';
	requires 'Test::NoWarnings';
	requires 'Test::RequiresInternet';
	requires 'Test::URI';
};
on 'develop' => sub {
	requires 'Devel::Cover';
	requires 'Perl::Critic';
	requires 'Test::Pod';
	requires 'Test::Pod::Coverage';
};
