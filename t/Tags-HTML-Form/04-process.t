use strict;
use warnings;

use Tags::HTML::Form;
use Tags::Output::Structure;
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
my $tags = Tags::Output::Structure->new;
my $obj = Tags::HTML::Form->new(
	'tags' => $tags,
);
$obj->process;
my $ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'form'],
		['a', 'class', 'form'],
		['a', 'method', 'GET'],
		['b', 'fieldset'],
		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', 'Save'],
		['e', 'button'],
		['e', 'p'],
		['e', 'fieldset'],
		['e', 'form'],
	],
	'Form HTML code (only submit button).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Form->new(
	'submit' => 'Custom save',
	'tags' => $tags,
);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'form'],
		['a', 'class', 'form'],
		['a', 'method', 'GET'],
		['b', 'fieldset'],
		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', 'Custom save'],
		['e', 'button'],
		['e', 'p'],
		['e', 'fieldset'],
		['e', 'form'],
	],
	'Form HTML code (only submit button with custom text).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Form->new(
	'tags' => $tags,
	'title' => 'Title',
);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'form'],
		['a', 'class', 'form'],
		['a', 'method', 'GET'],
		['b', 'fieldset'],
		['b', 'legend'],
		['d', 'Title'],
		['e', 'legend'],
		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', 'Save'],
		['e', 'button'],
		['e', 'p'],
		['e', 'fieldset'],
		['e', 'form'],
	],
	'Form HTML code (only submit button with title).',
);
