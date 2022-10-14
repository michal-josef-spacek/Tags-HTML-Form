use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Form::Input;
use Tags::Output::Raw;
use Test::More 'tests' => 7;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Form::Input->new;
isa_ok($obj, 'Tags::HTML::Form::Input');

# Test.
$obj = Tags::HTML::Form::Input->new(
	'tags' => Tags::Output::Raw->new,
);
isa_ok($obj, 'Tags::HTML::Form::Input');

# Test.
eval {
	Tags::HTML->new(
		'tags' => 'bad_tags',
	);
};
is($EVAL_ERROR, "Parameter 'tags' must be a 'Tags::Output::*' class.\n",
	"Parameter 'tags' must be a 'Tags::Output::*' class.");
clean();

# Test.
eval {
	Tags::HTML->new(
		'tags' => 0,
	);
};
is($EVAL_ERROR, "Parameter 'tags' must be a 'Tags::Output::*' class.\n",
	"Parameter 'tags' must be a 'Tags::Output::*' class.");
clean();

# Test.
eval {
	Tags::HTML->new(
		'css' => 'bad_css',
	);
};
is($EVAL_ERROR, "Parameter 'css' must be a 'CSS::Struct::Output::*' class.\n",
	"Parameter 'css' must be a 'CSS::Struct::Output::*' class.");
clean();

# Test.
eval {
	Tags::HTML->new(
		'css' => 0,
	);
};
is($EVAL_ERROR, "Parameter 'css' must be a 'CSS::Struct::Output::*' class.\n",
	"Parameter 'css' must be a 'CSS::Struct::Output::*' class.");
clean();
