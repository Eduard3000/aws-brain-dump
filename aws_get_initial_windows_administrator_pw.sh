#!/bin/bash

#using aws cli, jq, your users default region and account, pass it the instanceid

aws ec2 get-password-data --instance-id $1 | jq -c -r '.PasswordData' | xargs echo -n | base64 -d | openssl rsautl -decrypt -inkey ./your_private_key.pem | xargs echo
