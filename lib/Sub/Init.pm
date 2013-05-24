use strict;
use warnings;

package Sub::Init;

use parent 'Exporter';

our @EXPORT = qw/ initialised_sub initialized_sub init after /;

sub initialised_sub ($$) {
	my ($name, $init_after) = @_;
	my ($init, $after) = @$init_after;

	my $package = caller;

	my $sub_name = "${package}::$name";
	my $temp_sub  = sub {
		my @args = @_;
		$init->(@args);

		{
			no strict 'refs';
			no warnings 'redefine';
			*{$sub_name} = $after;
		}
		return $after->(@_);
	};

	{
		no strict 'refs';
		*{$sub_name} = $temp_sub;
	}
}

{
	no warnings 'once';
	*initialized_sub = *initialised_sub;
}

sub init (&$) { [@_] }
sub after (&) { shift }

1;
