#!/usr/bin/perl

if($ARGV[0] == "" or $ARGV[1] == ""){
print "usage perl $0 AWS-REGION EC2-INSTANCE-ID\n";
exit 1;
}


use Crypt::OpenSSL::RSA;
use MIME::Base64;

my ($pem_key_file) = './key.pem';

open(KEY,$pem_key_file) or die "Could not open pem!";
my (@priv_key) = <KEY>;
close(KEY);
$priv_key = join '',@priv_key;

$rsa = Crypt::OpenSSL::RSA->new_private_key($priv_key);
$rsa->use_sslv23_padding(); #funny: " RSA.xs:202: OpenSSL error: oaep decoding error at ..." happens without

# lets get the encoded password from your selected region and instance id

use Paws;
use Data::Printer;

my $region = $ARGV[0];
my $iid = $ARGV[1];
my $ec2 = Paws->service('EC2', region => $region);
my $gpd = $ec2->GetPasswordData(InstanceId => $iid);
my $pwd = $gpd->PasswordData;
chomp($pwd);

# decode with your pem and print
print "INITIAL_ADMIN_PW: ", $rsa->decrypt(decode_base64($pwd)),"\n";
