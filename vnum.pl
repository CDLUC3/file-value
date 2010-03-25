#!/usr/bin/perl -Ilib

use strict;
use warnings;

use File::Value;

# main program
{
	my ($template, $first_no_num) = @ARGV;
	$first_no_num ||= 0;

	my $msg;
	if ($first_no_num) {
		$msg = snag_file($template);
		print "nonum: ", (! $msg ? "snagged $template"
			: "$template: $msg"), "\n";
	}
	else {
		my ($x, $name) = snag_version($template);
		print "x=$x, got name=$name\n";
	}
}
