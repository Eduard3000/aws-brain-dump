# aws-brain-dump
All about AWS

# awswhoami
- 1st aws cli + jq (https://github.com/stedolan/jq):
put into .bashrc
```bash
alias awswhoami='aws iam list-account-aliases | jq -r '\''.AccountAliases[0]'\'''
```
 then source and 
```bash
awswhoami
```
will print your current default account alias

- 2nd perl
```perl
#!/usr/bin/perl
use Paws;
my $iam = Paws->service('IAM');
my $alias   = $iam->ListAccountAliases;
print $alias->AccountAliases->[0],"\n";
```
- 3rd php
```php
<?php
require '/home/fusers/php/aws/vendor/autoload.php';

use Aws\Iam\IamClient;
$aws = IamClient::factory(array(
    'version' => '2010-05-08',
    'profile' => 'default',
    'region'  => 'eu-central-1'
));

$result = $aws->listAccountAliases([]);
echo $result['AccountAliases'][0];
echo "\n";
?>
```
- 4th powershell, its simple, but first start is a bit slooow...
```powershell
Get-IAMAccountAlias
```

for more <a href="awswhoami.md">awswhoami</a>

- Get initial windows Administator pw with private key, aws cli, jq and openssl
```bash
aws ec2 get-password-data --instance-id $1 | jq -c -r '.PasswordData' | xargs echo -n | base64 -d -i | openssl rsautl -decrypt -inkey ./your_private_key.pem | xargs echo
```
<a href="aws_get_initial_windows_administrator_pw.sh">BASH</a> and for perl version see <a href="aws_get_initial_windows_administrator_pw.pl">this</a>

aws list all policies and their actions, incl. dump from "today"(sic)


