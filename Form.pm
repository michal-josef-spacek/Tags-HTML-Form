package Tags::HTML::Form;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Data::HTML::Button;
use Data::HTML::Form;
use Error::Pure qw(err);
use List::Util qw(first);
use Scalar::Util qw(blessed);
use Tags::HTML::Form::Input;
use Tags::HTML::Form::Select;
use Tags::HTML::Textarea;
use Tags::HTML::Button;

our $VERSION = 0.09;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['background_color', 'button', 'form', 'input', 'select',
		'submit', 'textarea'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Background color.
	$self->{'background_color'} = '#f2f2f2';

	# Button object.
	$self->{'button'} = undef;

	# Form.
	$self->{'form'} = Data::HTML::Form->new(
		'css_class' => 'form',
	);

	# Input object.
	$self->{'input'} = undef;

	# Select object.
	$self->{'select'} = undef;

	# Submit.
	$self->{'submit'} = Data::HTML::Button->new(
		'data' => [
			['d', 'Save'],
		],
		'data_type' => 'tags',
		'type' => 'submit',
	);

	# Textarea object.
	$self->{'textarea'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check form.
	if (! defined $self->{'form'}) {
		err "Parameter 'form' is required.";
	}
	if (! blessed($self->{'form'})
		|| ! $self->{'form'}->isa('Data::HTML::Form')) {

		err "Parameter 'form' must be a 'Data::HTML::Form' instance.";
	}
	if (! defined $self->{'form'}->{'css_class'}) {
		err "Parameter 'form' must define 'css_class' parameter.";
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

	$self->_tags_object_check('button', 'Tags::HTML::Button');
	$self->_tags_object_check('input', 'Tags::HTML::Form::Input');
	$self->_tags_object_check('select', 'Tags::HTML::Form::Select');
	$self->_tags_object_check('textarea', 'Tags::HTML::Textarea');

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, @fields) = @_;

	# Check fields.
	foreach my $field (@fields) {
		if (! defined $field
			|| ! blessed($field)
			|| (! $field->isa('Data::HTML::Form::Input')
			&& ! $field->isa('Data::HTML::Form::Select')
			&& ! $field->isa('Data::HTML::Textarea'))) {

			err "Form item must be a 'Data::HTML::Form::Input', ".
				"'Data::HTML::Textarea' or 'Data::HTML::Form::Select' instance.";
		}
	}

	$self->{'tags'}->put(
		['b', 'form'],
		defined $self->{'form'}->css_class ? (
			['a', 'class', $self->{'form'}->css_class],
		) : (),
		defined $self->{'form'}->action ? (
			['a', 'action', $self->{'form'}->action],
		) : (),
		['a', 'method', $self->{'form'}->method],

		defined $self->{'form'}->{'label'} ? (
			['b', 'fieldset'],
			['b', 'legend'],
			['d', $self->{'form'}->{'label'}],
			['e', 'legend'],
		) : (),
	);

	if (@fields) {
		$self->{'tags'}->put(
			['b', 'p'],
		);
	}

	foreach my $field (@fields) {
		$self->{'tags'}->put(
			defined $field->label ? (
				['b', 'label'],
				$field->id ? (
					['a', 'for', $field->id],
				) : (),
				['d', $field->label],
				$field->required ? (
					['b', 'span'],
					['a', 'class', $self->{'form'}->css_class.'-required'],
					['d', '*'],
					['e', 'span'],
				) : (),
				['e', 'label'],
			) : (),
		);

		if ($field->isa('Data::HTML::Form::Input')) {
			$self->{'input'}->process($field);
		} elsif ($field->isa('Data::HTML::Form::Select')) {
			$self->{'select'}->process($field);
		} else {
			$self->{'textarea'}->process($field);
		}
	}

	if (@fields) {
		$self->{'tags'}->put(
			['e', 'p'],
		);
	}

	$self->{'tags'}->put(
		['b', 'p'],
	);
	if ($self->{'submit'}->isa('Data::HTML::Form::Input')) {
		$self->{'input'}->process($self->{'submit'});
	} else {
		$self->{'button'}->process($self->{'submit'});
	}
	$self->{'tags'}->put(
		['e', 'p'],

		defined $self->{'form'}->{'label'} ? (
			['e', 'fieldset'],
		) : (),
		['e', 'form'],
	);

	return;
}

sub _process_css {
	my ($self, @fields) = @_;

	$self->{'css'}->put(
		['s', '.'.$self->{'form'}->css_class],
		['d', 'border-radius', '5px'],
		['d', 'background-color', $self->{'background_color'}],
		['d', 'padding', '20px'],
		['e'],

		['s', '.'.$self->{'form'}->css_class.' fieldset'],
		['d', 'padding', '20px'],
		['d', 'border-radius', '15px'],
		['e'],

		['s', '.'.$self->{'form'}->css_class.' legend'],
		['d', 'padding-left', '10px'],
		['d', 'padding-right', '10px'],
		['e'],

		['s', '.'.$self->{'form'}->css_class.'-required'],
		['d', 'color', 'red'],
		['e'],
	);

	# TODO Different objects and different CSS?
	my $first_input = first { ref $_ eq 'Data::HTML::Form::Input' } @fields;
	if (defined $first_input) {
		$self->{'input'}->process_css($first_input);
	}
	my $first_select = first { ref $_ eq 'Data::HTML::Form::Select' } @fields;
	if (defined $first_select) {
		$self->{'select'}->process_css($first_select);
	}
	my $first_textarea = first { ref $_ eq 'Data::HTML::Textarea' } @fields;
	if (defined $first_textarea) {
		$self->{'textarea'}->process_css($first_textarea);
	}

	if ($self->{'submit'}->isa('Data::HTML::Button')) {
		$self->{'button'}->process_css($self->{'submit'});
	}

	return;
}

sub _tags_object_check {
	my ($self, $param, $class) = @_;

	if (! defined $self->{$param}) {
		$self->{$param} = $class->new(
			'css' => $self->{'css'},
			'tags' => $self->{'tags'},
		);
	} else {
		if (! blessed($self->{$param}) || $self->{$param}->isa($class)) {
			err "Parameter '$param' must be a '$class' instance.";
		}
	}

	return;
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
 $obj->process(@fields);
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Form->new(%params);

Constructor.

=over 8

=item * C<background_color>

Form background color.

Default value is '#f2f2f2'.

=item * C<css>

'L<CSS::Struct::Output>' object for L</process_css> processing.

Default value is undef.

=item * C<button>

L<Tags::HTML::Button> instance to process button.

Default value is L<Tags::HTML::Button> object with 'tags' and 'css' parameter
inherited with main object.

=item * C<form>

Data object for form.

Could be a 'L<Data::HTML::Form>' instance.

Default value is instance with 'form' css class.

=item * C<input>

L<Tags::HTML::Form::Input> instance to process inputs.

Default value is L<Tags::HTML::Form::Input> object with 'tags' and 'css' parameter
inherited with main object.

=item * C<select>

L<Tags::HTML::Form::Select> instance to process select elements.

Default value is L<Tags::HTML::Form::Select> object with 'tags' and 'css' parameter
inherited with main object.

=item * C<submit>

Data object for submit.

Could be a 'L<Data::HTML::Form::Input>' or 'L<Data::HTML::Button>' instance.

Default value is instance with 'Save' submit value.

=item * C<tags>

'L<Tags::Output>' object for L</process> processing.

Default value is undef.

=item * C<textarea>

L<Tags::HTML::Textarea> instance to process textarea elements.

Default value is L<Tags::HTML::Textarea> object with 'tags' and 'css' parameter
inherited with main object.

=back

=head2 C<process>

 $obj->process(@fields);

Process L<Tags> structure for fields defined in C<@fields> to output.

Accepted items in C<@fields> are objects:

=over

=item * L<Data::HTML::Form::Input>

=item * L<Data::HTML::Textarea>

=back

Returns undef.

=head2 C<process_css>

 $obj->process_css;

Process L<CSS::Struct> structure for output.

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         From Tags::HTML::new():
                 Parameter 'css' must be a 'CSS::Struct::Output::*' class.
                 Parameter 'tags' must be a 'Tags::Output::*' class.
         Parameter 'button' must be a 'Tags::HTML::Button' instance.
         Parameter 'form' is required.
         Parameter 'form' must be a 'Data::HTML::Form' instance.
         Parameter 'form' must define 'css_class' parameter.
         Parameter 'input' must be a 'Tags::HTML::Form::Input' instance.
         Parameter 'select' must be a 'Tags::HTML::Form::Select' instance.
         Parameter 'submit' instance has bad type.
         Parameter 'submit' is required.
         Parameter 'submit' must be a 'Data::HTML::Form::Input' instance.
         Parameter 'textarea' must be a 'Tags::HTML::Textarea' instance.

 process():
         From Tags::HTML::process():
                 Parameter 'tags' isn't defined.
         Form item must be a 'Data::HTML::Form::Input' instance.

 process_css():
         From Tags::HTML::process_css():
                 Parameter 'css' isn't defined.

=head1 EXAMPLE

=for comment filename=default_form.pl

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

 # Process form.
 $obj->process;
 $obj->process_css;

 # Print out.
 print $tags->flush;
 print "\n\n";
 print $css->flush;

 # Output:
 # <form class="form" method="GET">
 #   <p>
 #     <button type="submit">
 #       Save
 #     </button>
 #   </p>
 # </form>
 # 
 # .form {
 #         border-radius: 5px;
 #         background-color: #f2f2f2;
 #         padding: 20px;
 # }
 # .form input[type=submit]:hover {
 #         background-color: #45a049;
 # }
 # .form input[type=submit] {
 #         width: 100%;
 #         background-color: #4CAF50;
 #         color: white;
 #         padding: 14px 20px;
 #         margin: 8px 0;
 #         border: none;
 #         border-radius: 4px;
 #         cursor: pointer;
 # }
 # .form input, select, textarea {
 #         width: 100%;
 #         padding: 12px 20px;
 #         margin: 8px 0;
 #         display: inline-block;
 #         border: 1px solid #ccc;
 #         border-radius: 4px;
 #         box-sizing: border-box;
 # }
 # .form-required {
 #         color: red;
 # }

=head1 DEPENDENCIES

L<Class::Utils>,
L<Data::HTML::Form>,
L<Data::HTML::Button>,
L<Error::Pure>,
L<List::Util>,
L<Scalar::Util>,
L<Tags::HTML>,
L<Tags::HTML::Form::Input>,
L<Tags::HTML::Form::Select>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Form>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2022-2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.09

=cut
