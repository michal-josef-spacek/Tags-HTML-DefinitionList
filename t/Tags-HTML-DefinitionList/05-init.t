use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::DefinitionList;
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::DefinitionList->new;
my $dl = [
	['one', 1],
	['two', 2],
];
my $ret = $obj->init($dl);
is($ret, undef, 'Init returns undef (definition list).');

# Test.
$obj = Tags::HTML::DefinitionList->new;
$ret = $obj->init;
is($ret, undef, 'Init returns undef (no definition list).');

# Test.
$obj = Tags::HTML::DefinitionList->new;
eval {
	$obj->init('');
};
is($EVAL_ERROR, "Definition list must be a reference to array.\n",
	"Definition list must be a reference to array ('').");
clean();
