#!/usr/bin/perl

use Paws;
use URI::Escape;
use JSON;
use Data::Printer;
use Scalar::Util qw(reftype);

my $iam = Paws->service('IAM');

my $alias   = $iam->ListAccountAliases;

print $alias->AccountAliases->[0],"\n";

my $ap = $iam->ListPolicies();

foreach my $p (@{$ap->Policies}){

#printf "%50s %50s\n",$p->PolicyName, $p->Arn;
getpva($p->PolicyName, $p->Arn);
}

sub getpva{
my $p = shift;
my $pa = shift;
my $v = getmaxversion($pa);

my $gpv = $iam->GetPolicyVersion(PolicyArn => $pa,VersionId => $v);

parsepva($p,$gpv->PolicyVersion->Document);

}

sub parsepva{
my $pn = shift;
my $pvd = shift;

my $j = decode_json(uri_unescape($pvd));

#p $j;
#print "Action: ";

if(reftype($j->{'Statement'}) eq 'ARRAY'){
foreach my $sa (@{$j->{'Statement'}}){
#p $sa;
if(reftype($sa->{'Action'}) eq 'ARRAY'){
foreach my $v (@{$sa->{'Action'}}){
#p $v;
printf "%40s %30s\n",$pn,$v,"\n";
}
}
else{
printf "%40s %30s\n",$pn,$sa->{'Action'};
}

}
}

print "\n";
}

sub getmaxversion{
my $parn = shift;

my $pvs = $iam->ListPolicyVersions(PolicyArn=>$parn);
my @pvl;
foreach my $pv (@{$pvs->Versions}){

push @pvl,$pv->VersionId;

}
my @pvls = sort(@pvl);
return $pvls[-1];
}
