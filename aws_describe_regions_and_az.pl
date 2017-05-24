#!/usr/bin/perl

use Paws;

my %CONF;
$CONF{'REGION'}   = 'eu-central-1'; # replace with your region

my $ec2 = Paws->service('EC2', region => $CONF{'REGION'});

my $dr  = $ec2->DescribeRegions();

printf "%-15s: %20s\n","Region","AZ-List";

my $regc,$azc = 0;

foreach my $region (@{$dr->Regions}){

	my $rn  = $region->RegionName;
	printf "%-15s: ",$rn;
	$regc++;	
	my $ec3 = Paws->service('EC2', region => $rn);

	my $daz = $ec3->DescribeAvailabilityZones();

	foreach my $az (@{$daz->AvailabilityZones}){

		printf "%15s ",$az->ZoneName;
		$azc++;
	
	}
	print "\n";
}

printf "Found %3d AZs in %3d Regions\n,",$azc,$regc;


