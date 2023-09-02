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
		['color', 'css_dl', 'lang'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Definition key color.
	$self->{'color'} = 'black';

	# CSS style for definition list.
	$self->{'css_dl'} = 'dl';

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
	foreach my $key (keys %{$self->{'_definition_list'}}) {
		$self->{'tags'}->put(
			['b', 'dt'],
			['d', $key],
			['e', 'dt'],
			['b', 'dd'],
			['d', $self->{'_definition_list'}->{$key}],
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
		['d', 'border', '3px double #ccc'],
		['d', 'padding', '0.5em'],
		['e'],

		['s', '.'.$self->{'css_dl'}.' dt'],
		['d', 'float', 'left'],
		['d', 'clear', 'left'],
		['d', 'width', '100px'],
		['d', 'text-align', 'right'],
		['d', 'font-weight', 'bold'],
		['d', 'color', $self->{'color'}],
		['e'],

		['s', '.'.$self->{'css_dl'}.' dt:after'],
		['d', 'content', ':'],
		['e'],

		['s', '.'.$self->{'css_dl'}.' dd'],
		['d', 'margin', '0 0 0 110px'],
		['d', 'padding', '0 0 0.5em 0'],
		['e'],
	);

	return;
}

sub _set_dl {
	my ($self, $definition_list_hr) = @_;

	if (! defined $definition_list_hr) {
		return;
	}

	$self->{'_definition_list'} = $definition_list_hr;

	return;
}

1;
