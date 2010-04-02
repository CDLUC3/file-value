use 5.006;
use Test::More qw( no_plan );
use strict;
use warnings;

my $script = "snag";		# script we're testing

# as of 2009.08.27  (SHELL stuff, remake_td, Config perlpath)
#### start boilerplate for script name and temporary directory support

use Config;
$ENV{SHELL} = "/bin/sh";
my $td = "td_$script";		# temporary test directory named for script
# Depending on circs, use blib, but prepare to use lib as fallback.
my $blib = (-e "blib" || -e "../blib" ?	"-Mblib" : "-Ilib");
my $bin = ($blib eq "-Mblib" ?		# path to testable script
	"blib/script/" : "") . $script;
my $perl = $Config{perlpath} . $Config{_exe};	# perl used in testing
my $cmd = "2>&1 $perl $blib " .		# command to run, capturing stderr
	(-x $bin ? $bin : "../$bin") . " ";	# exit status in $? >> 8

my ($rawstatus, $status);		# "shell status" version of "is"
sub shellst_is { my( $expected, $output, $label )=@_;
	$status = ($rawstatus = $?) >> 8;
	$status != $expected and	# if not what we thought, then we're
		print $output, "\n";	# likely interested in seeing output
	return is($status, $expected, $label);
}

use File::Path;
sub remake_td {		# make $td with possible cleanup
	-e $td			and remove_td();
	mkdir($td)		or die "$td: couldn't mkdir: $!";
}
sub remove_td {		# remove $td but make sure $td isn't set to "."
	! $td || $td eq "."	and die "bad dirname \$td=$td";
	eval { rmtree($td); };
	$@			and die "$td: couldn't remove: $@";
}

#### end boilerplate

use File::Value;

{	# elide tests

is elide("abcdefghi"), "abcdefghi", 'simple no-op';

is elide("abcdefghijklmnopqrstuvwxyz", "7m", ".."),
"ab..xyz", 'truncate explicit, middle';

is elide("abcdefghijklmnopqrstuvwxyz"),
"abcdefghijklmn..", 'truncate implicit, end';

is elide("abcdefghijklmnopqrstuvwxyz", 22),
"abcdefghijklmnopqrst..", 'truncate explicit, end';

is elide("abcdefghijklmnopqrstuvwxyz", 22, ".."),
"abcdefghijklmnopqrst..", 'truncate explicit, end, explicit ellipsis';

is elide("abcdefghijklmnopqrstuvwxyz", "22m"),
"abcdefghi...qrstuvwxyz", 'truncate explicit, middle';

is elide("abcdefghijklmnopqrstuvwxyz", "22m", ".."),
"abcdefghij..qrstuvwxyz", 'truncate explicit, middle, explicit ellipsis';

is elide("abcdefghijklmnopqrstuvwxyz", "22s"),
"..ghijklmnopqrstuvwxyz", 'truncate explicit, start';

# XXXX this +4% test isn't really implemented
is elide("abcdefghijklmnopqrstuvwxyz", "22m+4%", "__"),
"abcdefghij__qrstuvwxyz", 'truncate explicit, middle, alt. ellipsis';

}
