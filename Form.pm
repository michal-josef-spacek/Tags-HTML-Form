package Tags::HTML::Form;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['title'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Title.
	$self->{'title'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	$self->{'tags'}->put(
		['b', 'form'],
		['a', 'method', 'GET'],

		['b', 'fieldset'],
		$self->{'title'} ? (
		['b', 'legend'],
		['d', $self->{'title'}],
		['e', 'legend'],
		) : (),

		# TODO
		['b', 'p'],
		['b', 'label'],
		['a', 'for', 'category'],
		['e', 'label'],
		['d', 'Category'],
		['b', 'input'],
		['a', 'type', 'text'],
		['a', 'name', 'category'],
		['a', 'id', 'category'],
		['e', 'input'],
		['e', 'p'],

		['b', 'p'],
		['b', 'button'],
		['a', 'type', 'submit'],
		['a', 'name', 'page'],
		['a', 'value', 'category'],
		['d', 'View category'],
		['e', 'button'],
		['e', 'p'],

		['e', 'fieldset'],
		['e', 'form'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
	);

	return;
}

1;

__END__
