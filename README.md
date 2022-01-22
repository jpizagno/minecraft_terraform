# Minecraft Server via Terraform

This will start a Minecraft Server on a t2.medium EC2 instance.

The version of Java Minecraft is 1.18.1.

One can create the EC2 instance and start the server with the build.sh command like this:

```
jpizagno@jpizagno-Inspiron-7566:~/repository/minecraft_terraform$ ./build.sh 

using IPv4 of: 7.186.183.66

Enter AWS AWSAccessKeyId : AKIAXXXXXXO4MGZTFJQA

Enter AWS AWSSecretKey (see ~/.aws/credentials) : 7VzZaTGVAAAAAAAAAAAAAAAuFMCMyrbnA

PEM file key_name (jim-gastrofix) : jim-pem

PEM file location (/home/jpizagno/AWS/jim-gastrofix.pem) : /home/jpizagno/AWS/jim-gastrofix.pem

Initializing the backend...

Initializing provider plugins...
...

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

aws_instance_ec2_minecraft_server_public_ip = 3.71.25.15

please wait 5 mintues
```