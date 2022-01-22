#!/bin/bash

set -e

set -x


ipaddress=$(curl https://ipinfo.io/ip)
echo "using IPv4 of: "$ipaddress

read -p 'Enter AWS AWSAccessKeyId : ' access_key
echo
read -p 'Enter AWS AWSSecretKey (see ~/.aws/credentials) : ' secret_key
echo
read -p 'PEM file key_name (jim-gastrofix) : ' key_name
echo
read -p 'PEM file location (/home/jpizagno/AWS/jim-gastrofix.pem) : ' pem_file_location
echo

export TF_LOG=INFO
export TF_LOG_PATH=./terraform.log

terraform init ec2_config/
terraform apply -auto-approve  -var 'key_name='$key_name'' -var 'pem_file_location='$pem_file_location''  -var 'user_ip_address='$ipaddress'' -var 'access_key='$access_key'' -var 'secret_key='$secret_key''  -var-file="./ec2_config/terraform.tfvars" ec2_config/


echo #########################
echo "please wait 5 mintues"
echo 
echo #########################
