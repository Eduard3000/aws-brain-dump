#!/usr/bin/perl

# describes all ec2 instances, and prints their id, privateip and "Name" tag, each network acls and security group authroization
# or single instance if instance id is passt to

use Paws;

my %CONF;
$CONF{'REGION'}   = 'eu-central-1'; # replace with your region

my $ec2 = Paws->service('EC2', region => $CONF{'REGION'});

if(@ARGV == 0){
print "No instance-id passed, describeing all for current account\n";
}
else{
print "Describeing instance(s): ", (join ",",@ARGV),"\n";
}

$ec2di = $ec2->DescribeInstances(InstanceIds => [@ARGV]);

foreach $ec2res (@{$ec2di->Reservations}){
  foreach my $ec2ins (@{$ec2res->Instances}){

	printf "EC2: %20s; IP: %-16s;", $ec2ins->InstanceId,$ec2ins->PrivateIpAddress;
	
	my ($nametag) = $ec2->DescribeTags(Filters => [{Name => 'resource-id', Values => [$ec2ins->InstanceId]},{Name => 'key', Values => ['Name']}]);

	(defined($nametag->Tags->[0])) ? print " TAG->Name: ",$nametag->Tags->[0]->Value, "\n" : print " -> !!!NO NAME TAG!!!\n";

	descnacl($ec2ins->VpcId);

	foreach my $sgp (@{$ec2ins->SecurityGroups}){

		descsgp($sgp->GroupId);
	}
  }
}

sub descnacl{
my $vpcid = shift;

my $dnac = $ec2->DescribeNetworkAcls(Filters => [{Name => 'vpc-id', Values => [$vpcid]}]);


#p $dsgp;

foreach my $nac (@{$dnac->NetworkAcls}){

	printf "NAC: %16s %16s\n",$nac->NetworkAclId,$nac->VpcId;
	
	foreach my $ipp (@{$nac->Entries}){

		# p $ipp;
		printf "-->ACL: %3s %8s %16s %16s %8s %8s %6s\n",$ipp->Egress,$ipp->RuleNumber,(defined($ipp->CidrBlock) ? $ipp->CidrBlock : 'ALL'),(($ipp->Protocol == -1) ? 'ALL' : $ipp->Protocol),(($ipp->PortRange->From == -1) ? 'ALL' : $ipp->PortRange->From),(($ipp->PortRange->To == -1) ? 'ALL' : $ipp->PortRange->To),$ipp->RuleAction;
		} 

}

}

sub descsgp{
my $sgpid = shift;

my $dsgp = $ec2->DescribeSecurityGroups(Filters => [{Name => 'group-id', Values => [$sgpid]}]);

foreach my $sgp (@{$dsgp->SecurityGroups}){

	printf "SGP: %16s %16s\n",$sgp->GroupId,$sgp->GroupName;
	
	foreach my $ipp (@{$sgp->IpPermissions}){

		printf "-->ACL-IN: %16s %16s %8s %8s\n",(defined($ipp->IpRanges->[0]) ? $ipp->IpRanges->[0]->CidrIp : 'ALL'),(($ipp->IpProtocol == -1) ? 'ALL' : $ipp->IpProtocol),(($ipp->FromPort == -1) ? 'ALL' : $ipp->FromPort),(($ipp->ToPort == -1) ? 'ALL' : $ipp->ToPort);
		} 

	        foreach my $ipp (@{$sgp->IpPermissionsEgress}){

                printf "-->ACLOUT: %16s %16s %8s %8s\n",(defined($ipp->IpRanges->[0]) ? $ipp->IpRanges->[0]->CidrIp : 'ALL'),(($ipp->IpProtocol == -1) ? 'ALL' : $ipp->IpProtocol),(($ipp->FromPort == -1) ? 'ALL' : $ipp->FromPort),(($ipp->ToPort == -1) ? 'ALL' : $ipp->ToPort);
        	} 

}

}
