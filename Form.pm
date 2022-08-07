package Tags::HTML::Form;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Data::HTML::Button;
use Error::Pure qw(err);
use Scalar::Util qw(blessed);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_form', 'fields', 'submit', 'title'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS class for form.
	$self->{'css_form'} = 'form';

	# Fields.
	$self->{'fields'} = [];

	# Submit.
	$self->{'submit'} = Data::HTML::Button->new(
		'data' => [
			['d', 'Save'],
		],
		'type' => 'submit',
	);

	# Title.
	$self->{'title'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check fields.
	if (! defined $self->{'fields'}) {
		err "Parameter 'fields' is required.";
	}
	if (ref $self->{'fields'} ne 'ARRAY') {
		err "Parameter 'fields' must be a array.";
	}
	foreach my $field (@{$self->{'fields'}}) {
		if (! defined $field
			|| ! blessed($field)
			|| ! $field->isa('Data::HTML::Form::Input')) {

			err "Parameter 'fields' item must be a 'Data::HTML::Form::Input' instance.";
		}
	}

	# Check submit.
	if (! defined $self->{'submit'}) {
		err "Parameter 'submit' is required.";
	}
	if (! blessed($self->{'submit'})
		|| (! $self->{'submit'}->isa('Data::HTML::Form::Input')
		&& ! $self->{'submit'}->isa('Data::HTML::Button'))) {

		err "Parameter 'submit' must be a 'Data::HTML::Form::Input' instance.";
	}
	if ($self->{'submit'}->type ne 'submit') {
		err "Parameter 'submit' instance has bad type.";
	}

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	$self->{'tags'}->put(
		# TODO Data::HTML::Form
		['b', 'form'],
		['a', 'class', $self->{'css_form'}],
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

	foreach my $field (@{$self->{'fields'}}) {
		$self->{'tags'}->put(
			['b', 'label'],
			['a', 'for', $field->id],
			['d', $field->label],
			$field->required ? (
				['b', 'span'],
				['a', 'class', $self->{'css_form'}.'-required'],
				['d', '*'],
				['e', 'span'],
			) : (),
			['e', 'label'],

			$self->_tags_input($field),
		);
	}

	if (@{$self->{'fields'}}) {
		$self->{'tags'}->put(
			['e', 'p'],
		);
	}

	$self->{'tags'}->put(
		['b', 'p'],
		$self->{'submit'}->isa('Data::HTML::Form::Input') ? (
			$self->_tags_input($self->{'submit'}),
		) : (
			$self->_tags_button($self->{'submit'}),
		),
		['e', 'p'],

		['e', 'fieldset'],
		['e', 'form'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_form'}],
		# TODO
		['e'],
	);

	return;
}

sub _tags_button {
	my ($self, $object) = @_;

	return (
		['b', 'button'],
		['a', 'type', $self->{'submit'}->type],
		defined $self->{'submit'}->name ? (
			['a', 'name', $self->{'submit'}->name],
		) : (),
		defined $self->{'submit'}->value ? (
			['a', 'value', $self->{'submit'}->value],
		) : (),
		@{$self->{'submit'}->data},
		['e', 'button'],
	);
}

sub _tags_input {
	my ($self, $object) = @_;

	return (
		['b', 'input'],
		defined $object->css_class ? (
			['a', 'class', $object->css_class],
		) : (),
		['a', 'type', $object->type],
		defined $object->id ? (
			['a', 'name', $object->id],
			['a', 'id', $object->id],
		) : (),
		defined $object->value ? (
			['a', 'value', $object->value],
		) : (),
		defined $object->checked ? (
			['a', 'checked', 'checked'],
		) : (),
		defined $object->placeholder ? (
			['a', 'placeholder', $object->placeholder],
		) : (),
		['e', 'input'],
	);
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Form - Tags helper for form.

=head1 SYNOPSIS

 use Tags::HTML::Form;

 my $obj = Tags::HTML::Form->new(%params);
 $obj->process;
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Form->new(%params);

Constructor.

=over 8

=item * C<css>

'CSS::Struct::Output' object for L<process_css> processing.

Default value is undef.

=item * C<css_form>

Main CSS class of this block.

Default value is 'form'.

=item * C<fields>

Array of form items.

All items must be a 'Data::HTML::Form::Input' objects.

=item * C<submit>

Data object for submit.

Could be a 'Data::HTML::Form::Input' or 'Data::HTML::Button' instance.

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=item * C<title>

Form title.

Default value is undef = without title.

=back

=head2 C<process>

 $obj->process;

Process Tags structure for output with form.

Returns undef.

=head2 C<process_css>

 $obj->process_css;

Process CSS::Struct structure for output.

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         From Tags::HTML::new():
                 Parameter 'tags' must be a 'Tags::Output::*' class.
         Parameter 'fields' is required.
         Parameter 'fields' item must be a 'Data::HTML::Form::Input' instance.
         Parameter 'fields' must be a array.
         Parameter 'submit' instance has bad type.
         Parameter 'submit' is required.
         Parameter 'submit' must be a 'Data::HTML::Form::Input' instance.

 process():
         From Tags::HTML::process():
                 Parameter 'tags' isn't defined.

=head1 EXAMPLE

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Tags::HTML::Form;
 use Tags::Output::Indent;

 # Object.
 my $css = CSS::Struct::Output::Indent->new;
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Form->new(
         'css' => $css,
         'tags' => $tags,
 );

 # Process pager.
 $obj->process;
 $obj->process_css;

 # Print out.
 print $tags->flush;
 print "\n\n";
 print $css->flush;

 # Output:
 # <form class="form" method="GET">
 #   <fieldset>
 #     <p>
 #       <button type="submit">
 #         Save
 #       </button>
 #     </p>
 #   </fieldset>
 # </form>
 # 
 # .form {
 # }

=head1 DEPENDENCIES

L<Class::Utils>,
L<Data::HTML::Button>
L<Error::Pure>,
L<Scalar::Util>,
L<Tags::HTML>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Form>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2022 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
