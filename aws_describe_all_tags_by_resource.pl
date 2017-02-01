#!/usr/bin/perl

use Paws;

my %CONF;
$CONF{'REGION'} = 'eu-central-1';
my %R;
my $ec2 = Paws->service('EC2', region => $CONF{'REGION'});

my $dt = $ec2->DescribeTags();

foreach my $tag (@{$dt->Tags}){
#printf "%20s %20s %20s %20s\n",$tag->Key,$tag->Value,$tag->ResourceId,$tag->ResourceType;
$R{$tag->ResourceId}{'ResourceType'} = $tag->ResourceType;
$R{$tag->ResourceId}{$tag->Key}      = $tag->Value;
}

printf "%20s %20s %20s\n",'ResourceType','ResourceId','Key','Value';

foreach my $rid (sort { $R{$a}{'ResourceType'} cmp $R{$b}{'ResourceType'} } keys %R){

	printf "%19s: %20s\n",$R{$rid}{'ResourceType'},$rid;

  foreach my $rk (keys %{$R{$rid}}){
	  next if($rk eq 'ResourceType');	
  	  printf "%20s %20s %20s\n",'',$rk,$R{$rid}{$rk};
  }
  print "---\n";
}
