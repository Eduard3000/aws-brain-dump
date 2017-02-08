#!/bin/bash

#using aws cli, jq, your users default region and account, pass it the private key and InstanceId 

if [ -z "$1" ] || [ -z "$2" ]
then
echo "usage: "
echo "$0 keyfile InstanceID"
exit 1
fi

aws ec2 get-password-data --instance-id $2 | jq -c -r '.PasswordData' | xargs echo -n | base64 -d -i | openssl rsautl -decrypt -inkey $1 | xargs echo
