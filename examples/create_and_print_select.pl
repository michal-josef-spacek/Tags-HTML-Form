#!/usr/bin/env perl

use strict;
use warnings;

use CSS::Struct::Output::Indent;
use Data::HTML::Form::Select;
use Tags::HTML::Form::Select;
use Tags::Output::Indent;

# Object.
my $css = CSS::Struct::Output::Indent->new;
my $tags = Tags::Output::Indent->new(
        'xml' => 1,
);
my $obj = Tags::HTML::Form::Select->new(
        'css' => $css,
        'tags' => $tags,
);

# Data object for select.
my $select = Data::HTML::Form::Select->new(
        'css_class' => 'form-select',
);

# Process select.
$obj->process($select);
$obj->process_css($select);

# Print out.
print "HTML:\n";
print $tags->flush;
print "\n\n";
print "CSS:\n";
print $css->flush;

# Output:
# HTML:
# <select class="form-select" type="text" />
#
# CSS:
# select.form-select {
#         width: 100%;
#         padding: 12px 20px;
#         margin: 8px 0;
#         display: inline-block;
#         border: 1px solid #ccc;
#         border-radius: 4px;
#         box-sizing: border-box;
# }