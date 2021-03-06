#!/usr/bin/perl

# describes all ec2 instances for all regions, and prints their id, privateip and "Name" tag, if there

use Paws;
use Data::Printer;

my %CONF;
$CONF{'REGION'}   = 'eu-central-1'; # replace with your region

my $ec2 = Paws->service('EC2', region => $CONF{'REGION'} );

my $dr = $ec2->DescribeRegions();

foreach my $reg (@{$dr->Regions}){
print $reg->RegionName,"\n";
descec2i4r($reg->RegionName);
}

sub descec2i4r{
my ($region) = shift;
my $ec2 = Paws->service('EC2', region => $region);

$ec2di = $ec2->DescribeInstances();

foreach $ec2res (@{$ec2di->Reservations}){
  foreach my $ec2ins (@{$ec2res->Instances}){

	printf "EC2: %20s; IP: %-16s;", $ec2ins->InstanceId,$ec2ins->PrivateIpAddress;
	
	my ($nametag) = $ec2->DescribeTags(Filters => [{Name => 'resource-id', Values => [$ec2ins->InstanceId]},{Name => 'key', Values => ['Name']}]);

	(defined($nametag->Tags->[0])) ? print " TAG->Name: ",$nametag->Tags->[0]->Value, "\n" : print " -> !!!NO NAME TAG!!!\n";

  }
}
}
