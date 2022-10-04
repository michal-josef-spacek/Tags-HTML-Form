use strict;
use warnings;

use Data::HTML::Button;
use Data::HTML::Form;
use Data::HTML::Form::Input;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Form;
use Tags::Output::Structure;
use Test::More 'tests' => 8;
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
		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', 'Save'],
		['e', 'button'],
		['e', 'p'],
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
		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', 'Custom save'],
		['e', 'button'],
		['e', 'p'],
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
		['b', 'p'],
		['b', 'input'],
		['a', 'type', 'submit'],
		['a', 'value', 'Custom save'],
		['e', 'input'],
		['e', 'p'],
		['e', 'form'],
	],
	'Form HTML code (only submit button with custom text).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Form->new(
	'tags' => $tags,
);
my $checkbox = Data::HTML::Form::Input->new(
	'checked' => 0,
	'type' => 'checkbox',
);
$obj->process($checkbox);
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'form'],
		['a', 'class', 'form'],
		['a', 'method', 'get'],
		['b', 'p'],
		['b', 'input'],
		['a', 'type', 'checkbox'],
		['e', 'input'],
		['e', 'p'],
		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', 'Save'],
		['e', 'button'],
		['e', 'p'],
		['e', 'form'],
	],
	'Form HTML code (checkbox with submit button).',
);

# Test.
$obj = Tags::HTML::Form->new;
eval {
	$obj->process;
};
is($EVAL_ERROR, "Parameter 'tags' isn't defined.\n",
	"Parameter 'tags' isn't defined.");
clean();

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Form->new(
	'tags' => $tags,
);
eval {
	$obj->process('bad');
};
is($EVAL_ERROR, "Form item must be a 'Data::HTML::Form::Input' instance.\n",
	"Form item must be a 'Data::HTML::Form::Input' instance.");
clean();
