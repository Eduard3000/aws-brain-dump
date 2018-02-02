#!/usr/bin/perl

# describes all ec2 instances for all regions, and prints their id, privateip and "Name" tag, if there

use Paws;
use Data::Printer(max_depth => 0,class => {expand => 'all'});

my %CONF;
$CONF{'REGION'}   = 'eu-central-1'; # replace with your region

my $ec2 = Paws->service('EC2', region => $CONF{'REGION'} );

my $dr = $ec2->DescribeRegions();

foreach my $reg (@{$dr->Regions}){
#print $reg->RegionName,"\n";
#descsph4r($reg->RegionName);
}
descsph4r('eu-central-1');

sub descsph4r{
my ($region) = shift;
my $ec2 = Paws->service('EC2', region => $region);

my $ec2dsph = $ec2->DescribeSpotPriceHistory(InstanceTypes => ['m4.16xlarge'], Filters => [{Name => 'product-description', Values => ["Linux/UNIX"]}]);

#p $ec2dsph;

foreach $sph (@{$ec2dsph->SpotPriceHistory}){

#p $sph;
my $ts = $sph->Timestamp;
$ts =~ s/\T/ /;
$ts =~ s/\.000Z//;
printf "%s;%s;%f\n",$sph->AvailabilityZone,$ts,$sph->SpotPrice;
}

}
