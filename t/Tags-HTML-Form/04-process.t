use strict;
use warnings;

use Data::HTML::Button;
use Data::HTML::Form;
use Data::HTML::Form::Input;
use Tags::HTML::Form;
use Tags::Output::Structure;
use Test::More 'tests' => 5;
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
		['a', 'method', 'get'],
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
	'submit' => Data::HTML::Button->new(
		'data' => [
			['d', 'Custom save'],
		],
		'type' => 'submit',
	),
	'tags' => $tags,
);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'form'],
		['a', 'class', 'form'],
		['a', 'method', 'get'],
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
	'form' => Data::HTML::Form->new(
		'css_class' => 'form',
		'label' => 'Title',
	),
);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'form'],
		['a', 'class', 'form'],
		['a', 'method', 'get'],
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

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Form->new(
	'submit' => Data::HTML::Form::Input->new(
		'value' => 'Custom save',
		'type' => 'submit',
	),
	'tags' => $tags,
);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'form'],
		['a', 'class', 'form'],
		['a', 'method', 'get'],
		['b', 'fieldset'],
		['b', 'p'],
		['b', 'input'],
		['a', 'type', 'submit'],
		['a', 'value', 'Custom save'],
		['e', 'input'],
		['e', 'p'],
		['e', 'fieldset'],
		['e', 'form'],
	],
	'Form HTML code (only submit button with custom text).',
);
