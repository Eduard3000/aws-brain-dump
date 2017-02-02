#!/usr/bin/perl

use Paws;

my %CONF;
$CONF{'REGION'}   = 'eu-central-1';

my $ec2 = Paws->service('EC2', region => $CONF{'REGION'});

$vpc1 = $ec2->DescribeVpcs();

foreach my $vpc (@{$vpc1->Vpcs}){
print "---\n";
printf "VPCId: %20s, %33s : %20s\n",$vpc->VpcId,'CIDR',$vpc->CidrBlock;
  foreach my $tag (@{$vpc->Tags}){
    printf "->KEY: %20s, VALUE: %20s\n",$tag->Key,$tag->Value;
  }
descsub($vpc->VpcId);
}

sub descsub{
my ($vpcid) = shift;

my $subs = $ec2->DescribeSubnets(Filters => [{'Name'=>'vpc-id',Values=>[$vpcid]}]); 
foreach my $sub (@{$subs->Subnets}){
printf "SUBId: %20s, VPCId: %20s, CIDR : %20s\n",$sub->SubnetId,$sub->VpcId,$sub->CidrBlock;
  foreach my $tag (@{$sub->Tags}){
    printf "->KEY: %20s, VALUE: %20s\n",$tag->Key,$tag->Value;
  }
}

}

