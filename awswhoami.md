# aws-brain-dump
All about AWS

# awswhoami
# 1st aws cli + jq (https://github.com/stedolan/jq):
# put into .bashrc
```bash
alias awswhoami='aws iam list-account-aliases | jq -r '\''.AccountAliases[0]'\'''
```
# then
```bash
awswhoami
```
# will print your current default account alias

#2nd perl
```perl
#!/usr/bin/perl
use Paws;
my $iam = Paws->service('IAM');
my $alias   = $iam->ListAccountAliases;
print $alias->AccountAliases->[0],"\n";
```
#3rd php
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
```ruby
#4th ruby

equire 'aws-sdk'

iam = Aws::IAM::Client.new(region: 'eu-central-1')

resp = iam.list_account_aliases({})
print resp.account_aliases[0]
print "\n"
```
#5th nodejs
```javascript
var AWS = require('aws-sdk');

var iam = new AWS.IAM();

var params = {};

 iam.listAccountAliases(params, function(err, data) {
   if (err) console.log(err, err.stack); // an error occurred
   else  {
  console.log(data.AccountAliases[0]);
  }
 });
```
#6th python
```python
import boto3

client = boto3.client('iam')
response = client.list_account_aliases()
print (response['AccountAliases'][0])
```
#7th powershell, its simple, but first start is a bit slooow...
```powershell
Get-IAMAccountAlias
```
