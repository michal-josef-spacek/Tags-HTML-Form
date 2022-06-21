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
		['fields', 'submit', 'submit_name', 'submit_value', 'title'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Fields.
	$self->{'fields'} = [];

	# Submit button.
	$self->{'submit'} = 'Save';

	# Submit name.
	$self->{'submit_name'} = undef;

	# Submit value.
	$self->{'submit_value'} = undef;

	# Title.
	$self->{'title'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check fields.
	# TODO

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
	);

	if (@{$self->{'fields'}}) {
		$self->{'tags'}->put(
			['b', 'p'],
		);
	}

	foreach my $field_hr (@{$self->{'fields'}}) {
		# TODO Rewrite to data object.
		$self->{'tags'}->put(
			['b', 'label'],
			['a', 'for', $field_hr->{'id'}],
			['e', 'label'],
			['d', $field_hr->{'text'}],
			['b', 'input'],
			['a', 'type', $field_hr->{'type'}],
			['a', 'name', $field_hr->{'id'}],
			['a', 'id', $field_hr->{'id'}],
			['e', 'input'],
		);
	}

	if (@{$self->{'fields'}}) {
		$self->{'tags'}->put(
			['e', 'p'],
		);
	}

	$self->{'tags'}->put(
		$self->{'submit'} ? (
			['b', 'p'],
			['b', 'button'],
			['a', 'type', 'submit'],
			defined $self->{'submit_name'} ? (
				['a', 'name', $self->{'submit_name'}],
			) : (),
			defined $self->{'submit_value'} ? (
				['a', 'value', $self->{'submit_value'}],
			) : (),
			['d', $self->{'submit'}],
			['e', 'button'],
			['e', 'p'],
		) : (),

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
