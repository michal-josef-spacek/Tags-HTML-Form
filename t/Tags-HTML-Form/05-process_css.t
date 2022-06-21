use strict;
use warnings;

use CSS::Struct::Output::Structure;
use Tags::HTML::Form;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $css = CSS::Struct::Output::Structure->new;
my $obj = Tags::HTML::Form->new(
	'css' => $css,
);
$obj->process_css;
my $ret_ar = $css->flush(1);
is_deeply(
	$ret_ar,
	[
		['s', '.form'],
		['e'],
	],
	'Pager CSS code (stub).',
);
