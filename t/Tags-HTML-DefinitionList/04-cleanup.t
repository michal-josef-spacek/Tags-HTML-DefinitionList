use strict;
use warnings;

use Tags::HTML::DefinitionList;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::DefinitionList->new;
my $ret = $obj->cleanup;
is($ret, undef, 'Cleanup returns undef.');
