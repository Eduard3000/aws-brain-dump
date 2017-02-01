#!/usr/bin/perl

use Paws;

my %CONF;
$CONF{'REGION'} = 'eu-central-1';

my $ec2 = Paws->service('EC2', region => $CONF{'REGION'});

my $dt = $ec2->DescribeTags();

foreach my $tag (@{$dt->Tags}){
printf "%20s %20s %20s %20s\n",$tag->Key,$tag->Value,$tag->ResourceId,$tag->ResourceType;
}

