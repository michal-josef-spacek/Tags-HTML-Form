package Tags::HTML::Form::Select::Option;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use Scalar::Util qw(blessed);

our $VERSION = 0.05;

# Process 'Tags'.
sub _process {
	my ($self, $option) = @_;

	# Check input.
	if (! defined $option
		|| ! blessed($option)
		|| ! $option->isa('Data::HTML::Form::Select::Option')) {

		err "Option object must be a 'Data::HTML::Form::Select::Option' instance.";
	}

	$self->{'tags'}->put(
		['b', 'option'],
		defined $option->css_class ? (
			['a', 'class', $option->css_class],
		) : (),
		defined $option->id ? (
			['a', 'name', $option->id],
			['a', 'id', $option->id],
		) : (),
		$option->disabled ? (
			['a', 'disabled', 'disabled'],
		) : (),
		$option->selected ? (
			['a', 'selected', 'selected'],
		) : (),
		defined $option->value ? (
			['a', 'value', $option->value],
		) : (),
		# TODO Other. https://www.w3schools.com/tags/tag_option.asp
	);
	if ($option->data_type eq 'plain') {
		$self->{'tags'}->put(
			['d', $option->data],
		);
	} elsif ($option->data_type eq 'tags') {
		$self->{'tags'}->put($option->data);
	}
	$self->{'tags'}->put(
		['e', 'option'],
	);

	return;
}

sub _process_css {
	my ($self, $option) = @_;

	# Check option.
	if (! defined $option
		|| ! blessed($option)
		|| ! $option->isa('Data::HTML::Form::Select::Option')) {

		err "Option object must be a 'Data::HTML::Form::Select::Option' instance.";
	}

	my $css_class = '';
	if (defined $option->css_class) {
		$css_class = '.'.$option->css_class;
	}

	$self->{'css'}->put(
		# TODO Implement consistent CSS.
	);

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

TODO
Tags::HTML::Form::Select::Option - Tags helper for form input element.

=head1 SYNOPSIS

 use Tags::HTML::Form::Select::Option;

 my $obj = Tags::HTML::Form::Select::Option->new(%params);
 $obj->process($input);
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Form::Select::Option->new(%params);

Constructor.

=over 8

=item * C<css>

'CSS::Struct::Output' object for L<process_css> processing.

Default value is undef.

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process($input);

Process Tags structure for fields defined in C<@fields> to output.

Accepted C<$input> is L<Data::HTML::Form::Select::Option>.

Returns undef.

=head2 C<process_css>

 $obj->process_css;

Process CSS::Struct structure for output.

Returns undef.

=head1 ERRORS

 new():
         From Tags::HTML::new():
                 Parameter 'css' must be a 'CSS::Struct::Output::*' class.
                 Parameter 'tags' must be a 'Tags::Output::*' class.

 process():
         From Tags::HTML::process():
                 Parameter 'tags' isn't defined.
         Input object must be a 'Data::HTML::Form::Select::Option' instance.

 process_css():
         From Tags::HTML::process_css():
                 Parameter 'css' isn't defined.
         Input object must be a 'Data::HTML::Form::Select::Option' instance.

=head1 EXAMPLE

=for comment filename=create_and_print_input.pl

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Data::HTML::Form::Select::Option;
 use Tags::HTML::Form::Select::Option;
 use Tags::Output::Indent;

 # Object.
 my $css = CSS::Struct::Output::Indent->new;
 my $tags = Tags::Output::Indent->new(
         'xml' => 1,
 );
 my $obj = Tags::HTML::Form::Select::Option->new(
         'css' => $css,
         'tags' => $tags,
 );

 # Data object for input.
 my $input = Data::HTML::Form::Select::Option->new(
         'css_class' => 'form-input',
 );

 # Process input.
 $obj->process($input);
 $obj->process_css($input);

 # Print out.
 print "HTML:\n";
 print $tags->flush;
 print "\n\n";
 print "CSS:\n";
 print $css->flush;

 # Output:
 # HTML:
 # <input class="form-input" type="text" />
 #
 # CSS:
 # input.form-input[type=submit]:hover {
 #         background-color: #45a049;
 # }
 # input.form-input[type=submit] {
 #         width: 100%;
 #         background-color: #4CAF50;
 #         color: white;
 #         padding: 14px 20px;
 #         margin: 8px 0;
 #         border: none;
 #         border-radius: 4px;
 #         cursor: pointer;
 # }
 # input.form-input {
 #         width: 100%;
 #         padding: 12px 20px;
 #         margin: 8px 0;
 #         display: inline-block;
 #         border: 1px solid #ccc;
 #         border-radius: 4px;
 #         box-sizing: border-box;
 # }

=head1 DEPENDENCIES

L<Class::Utils>,
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

0.05

=cut
