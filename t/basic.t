use strict;
use warnings;

use Test::More;

# So the prototypes are known and we can use runtime use_ok
sub initialised_sub ($$);
sub init (&$);
sub after (&);

use_ok 'Sub::Init';

my ($init, $called) = (0, 1);
initialised_sub 'foo' =>
	init {
		++$init;
	} after {
		++$called;
	};

my $result = foo();
is $init,   1, 'Initialisation called on first sub call';
is $called, 2, 'Sub itself called on first sub call';
is $result, 2, 'Result of after returned';

($init, $called) = (0, 1);

$result = foo();
is $init,   0, 'Initialisation NOT called on second sub call';
is $called, 2, 'Sub itself called on second sub call';
is $result, 2, 'Result of after returned';

done_testing;
