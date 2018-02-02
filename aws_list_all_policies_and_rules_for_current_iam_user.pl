#!/usr/bin/perl

use Paws;
use URI::Escape;
use JSON;
use Scalar::Util qw(reftype);
use Data::Printer(max_depth => 0,class => {expand => 'all'});

my $iam = Paws->service('IAM');

my $user   = $iam->GetUser;

print $user->User->UserName,"\n";

my $lg = $iam->ListGroupsForUser(UserName => $user->User->UserName);

foreach $g (@{$lg->Groups}){

p $g->GroupName;
listattachedgrouppolicies($g->GroupName);

}

sub listattachedgrouppolicies{
my $gn = shift;

my $gps = $iam->ListAttachedGroupPolicies(GroupName => $gn);
#p $gp;
foreach $p (@{$gps->AttachedPolicies}){
getpva($p->PolicyName, $p->PolicyArn);
}
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

