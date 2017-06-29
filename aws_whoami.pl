#!/usr/bin/perl

use Paws;

my $iam = Paws->service('IAM');

my $alias   = $iam->ListAccountAliases;

print $alias->AccountAliases->[0],"\n";

