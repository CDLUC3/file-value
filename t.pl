#!/bin/sh
#! -*- perl -*-
eval 'exec perl -x -S $0 ${1+"$@"} ;'
	if 0;
# Above 4 lines make for portable Perl script startup honoring PATH.  Don't
# change lightly.  Options may be inserted before "-x".  For background see
# 'perdoc perlrun' and http://cr.yp.to/slashpackage/studies/findingperl/7 .

use BerkeleyDB;

s/x/yyy/;

print "done\n";
