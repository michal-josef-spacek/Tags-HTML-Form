use strict;
use warnings;

use Tags::HTML::Form;
use Tags::Output::Raw;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Form->new;
isa_ok($obj, 'Tags::HTML::Form');

# Test.
$obj = Tags::HTML::Form->new(
	'tags' => Tags::Output::Raw->new,
);
isa_ok($obj, 'Tags::HTML::Form');
