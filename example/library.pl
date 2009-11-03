#!perl -w

use strict;

my $default  = 'default.out';
my $library  = 'library.out';

my @lib = '-MB::Shared';
if(exists $INC{'blib.pm'}){
	unshift @lib, '-Mblib';
}

system($^X, @lib, '-e', "B::Shared::dump(q{$default}, 0)") == 0 or die $!;
push @lib, map{ '-M' . $_ } @ARGV;
system($^X, @lib, '-e', "B::Shared::dump(q{$library}, 0)") == 0 or die $!;

system 'diff', $default, $library;

unlink $default;
unlink $library;
