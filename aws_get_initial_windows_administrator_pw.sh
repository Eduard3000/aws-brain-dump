#!/bin/bash

#using aws cli, jq, your users default region and account

aws ec2 get-password-data --instance-id $1 | jq -c -r '.PasswordData' | xargs echo -n | base64 -d key ../your_private_key.pem | xargs echo
