#!perl -w

use strict;
use Benchmark qw(:all);

use B::Shared;

my $shared = B::Shared::new_shared_str('foobar'); # ensure it to be

print "Create and destroy\n";
cmpthese -1 => {
    normal => sub{
        for(1 .. 100){
            my $s = B::Shared::new_str('foobar');
        }
    },
    shared => sub{
        for(1 .. 100){
            my $s = B::Shared::new_shared_str('foobar');
        }
    },
};

print "Create, access, and destroy\n";
cmpthese -1 => {
    normal => sub{
        my %h;
        for(1 .. 100){
            $h{ B::Shared::new_str('foobar') }++;
        }
    },
    shared => sub{
        my %h;
        for(1 .. 100){
            $h{ B::Shared::new_shared_str('foobar') }++;
        }
    },
};


my $key_normal = B::Shared::new_str('foobar');
my $key_shared = B::Shared::new_shared_str('foobar');

print "Hash access\n";
cmpthese -1 => {
    normal => sub{
        my %h;
        for(1 .. 100){
            $h{$key_normal}++;
        }
    },
    shared => sub{
        my %h;
        for(1 .. 100){
            $h{$key_shared}++;
        }
    },
    bare => sub{
        my %h;
        for(1 .. 100){
            $h{foobar}++;
        }
    },
};

