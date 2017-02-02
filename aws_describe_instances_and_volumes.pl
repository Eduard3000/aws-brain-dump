#!/usr/bin/perl

# describes all ec2 instances, and prints their id, privateip and "Name" tag, if there

use Paws;
use Data::Printer;

my %CONF;
$CONF{'REGION'}   = 'eu-central-1'; # replace with your region

my $ec2 = Paws->service('EC2', region => $CONF{'REGION'});

$ec2di = $ec2->DescribeInstances();

foreach $ec2res (@{$ec2di->Reservations}){
  foreach my $ec2ins (@{$ec2res->Instances}){
	printf "EC2: %25s  IP: %-20s ", $ec2ins->InstanceId,$ec2ins->PrivateIpAddress;
	
	my ($nametag) = $ec2->DescribeTags(Filters => [{Name => 'resource-id', Values => [$ec2ins->InstanceId]},{Name => 'key', Values => ['Name']}]);

	(defined($nametag->Tags->[0])) ? print " TAG->Name: ",$nametag->Tags->[0]->Value, "\n" : print " -> !!!NO NAME TAG!!!\n";

descvol($ec2ins);

  }
}

sub descvol{
my ($ei) = shift;

printf "%9s %20s %24s %4s %5s\n",'','DeviceName','VolumeId','Size','Iops';

foreach my $bd (@{$ei->BlockDeviceMappings}){
#p $bd;
my ($vid) = $bd->Ebs->VolumeId;
my $vols = $ec2->DescribeVolumes(VolumeIds => [$vid]);
printf "--Volume: %20s %24s %4d %5d\n",$bd->DeviceName,$vols->Volumes->[0]->VolumeId,$vols->Volumes->[0]->Size,$vols->Volumes->[0]->Iops;

}

}
