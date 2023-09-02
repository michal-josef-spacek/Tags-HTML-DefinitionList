package Tags::HTML::DefinitionList;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['border', 'color', 'css_dl', 'dd_left_padding', 'dt_sep', 'dt_width', 'lang'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Border of dl.
	# XXX 3px double #ccc
	$self->{'border'} = undef;

	# Definition key color.
	$self->{'color'} = 'black';

	# CSS style for definition list.
	$self->{'css_dl'} = 'dl';

	# Left padding after term.
	$self->{'dd_left_padding'} = '110px';

	# Definition term separator.
	$self->{'dt_sep'} = ':';

	# Definition term width.
	$self->{'dt_width'} = '100px';

	$self->{'lang'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

sub _cleanup {
	my $self = shift;

	delete $self->{'_definition_list'};

	return;
}

sub _init {
	my ($self, @params) = @_;

	return $self->_set_dl(@params);
}

sub _prepare {
	my ($self, @params) = @_;

	return $self->_set_dl(@params);
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	if (! exists $self->{'_definition_list'}) {
		return;
	}

	$self->{'tags'}->put(
		['b', 'dl'],
		['a', 'class', $self->{'css_dl'}],
	);
	foreach my $item_ar (@{$self->{'_definition_list'}}) {
		$self->{'tags'}->put(
			['b', 'dt'],
			['d', $item_ar->[0]],
			['e', 'dt'],
			['b', 'dd'],
			['d', $item_ar->[1]],
			['e', 'dd'],
		);
	}
	$self->{'tags'}->put(
		['e', 'dl'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_dl'}],
		defined $self->{'border'} ? (
			['d', 'border', $self->{'border'}],
		) : (),
		['d', 'padding', '0.5em'],
		['e'],

		['s', '.'.$self->{'css_dl'}.' dt'],
		['d', 'float', 'left'],
		['d', 'clear', 'left'],
		['d', 'width', $self->{'dt_width'}],
		['d', 'text-align', 'right'],
		['d', 'font-weight', 'bold'],
		['d', 'color', $self->{'color'}],
		['e'],

		['s', '.'.$self->{'css_dl'}.' dt:after'],
		['d', 'content', '"'.$self->{'dt_sep'}.'"'],
		['e'],

		['s', '.'.$self->{'css_dl'}.' dd'],
		['d', 'margin', '0 0 0 '.$self->{'dd_left_padding'}],
		['d', 'padding', '0 0 0.5em 0'],
		['e'],
	);

	return;
}

sub _set_dl {
	my ($self, $definition_list_ar) = @_;

	if (! defined $definition_list_ar) {
		return;
	}
	if (ref $definition_list_ar ne 'ARRAY') {
		err 'Definition list must be a reference to array.';
	}

	$self->{'_definition_list'} = $definition_list_ar;

	return;
}

1;
