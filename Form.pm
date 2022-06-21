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
		['css_form', 'fields', 'submit', 'submit_name', 'submit_value', 'title'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS class for form.
	$self->{'css_form'} = 'form';

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
		['s', '.'.$self->{'css_form'}],
		# TODO
		['e'],
	);

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
 # TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Readonly>,
L<Tags::HTML>,
L<Unicode::UTF8>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Form>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2022

BSD 2-Clause License

=head1 VERSION

0.01

=cut
