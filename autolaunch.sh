#!/bin/bash

# TODO 
# Be kinder to myself
# Watch the weight
# Floss more
# Test on more platforms. So far, testing has been done on: osx (Darwin)



# Check package manager and download awscli
# From: https://unix.stackexchange.com/a/571192

packagesNeeded='awscli'
if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $packagesNeeded
elif [ -x "$(command -v brew)" ];    then brew install $packagesNeeded
elif [ -x "$(command -v apt-get)" ]; then sudo apt-get install $packagesNeeded
elif [ -x "$(command -v dnf)" ];     then sudo dnf install $packagesNeeded
elif [ -x "$(command -v zypper)" ];  then sudo zypper install $packagesNeeded
elif [ -x "$(command -v yum)" ];     then sudo yum install $packagesNeeded

else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; 
fi

# Having user add aws access keys to be able to run script
echo "You will need your access key from your AWS account to paste into the next step" 
read -r -p 'Stop and get that if you need it: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey_CLIAPI (Press any key to continue)' -n1 -s && echo ' '

sleep 2

aws configure


read -r -p 'First deleting any old instances and any unused elastic ips aka cancel this if thats not ok. This may take a minute. (Press any key to continue)' -n1 -s && echo ' '

# Deletes any instances with invisibli tag
aws ec2 describe-instances --filters "Name=instance.group-name,Values='invisibli'" --output text --query 'Reservations[*].Instances[*].InstanceId' > deleteid.txt
doid=$(cat deleteid.txt)
aws ec2 terminate-instances --instance-ids $doid

echo "Waiting 30 seconds to allow any extra instances to terminate"

sleep 30

echo "Now deleting unused elastic IPs"

# Deletes any unssigned elastic IP
aws ec2 describe-addresses --query 'Addresses[].[AllocationId,AssociationId]' --output text | \
awk '$2 == "None" { print $1 }' | \
xargs -I {} aws ec2 release-address --allocation-id {}

sleep 10

echo "We will create your SSH keys now. They will be named invisibli.pem. Any prior ones with the same name will be overwritten."
sleep 5

# delete old key from AWS

aws ec2 delete-key-pair --key-name invisibli


# Move to key storage and remove old key from your machine 

rm invisibli.pem

# generate new key

aws ec2 create-key-pair --key-name invisibli --query 'KeyMaterial' --output text > invisibli.pem

# set key permissions

chmod 400 invisibli.pem

# deleting and remaking security groups

aws ec2 delete-security-group --group-name invisibli

aws ec2 create-security-group --group-name invisibli --description "invisibli security group"

# enable ssh port and default Wireguard port
# you will need to change the Wireguard port from 51820 if you decide to use something other then the default
aws ec2 authorize-security-group-ingress --group-name invisibli --protocol tcp --port 22 --cidr "0.0.0.0/0"

aws ec2 authorize-security-group-ingress --group-name invisibli --protocol udp --port 51820 --cidr "0.0.0.0/0"

# spin up new aws instance 

aws ec2 run-instances --image-id ami-08fa7c8891945eae4 --count 1 --instance-type t2.micro --key-name invisibli --security-groups invisibli --tag-specifications 'ResourceType=instance,Tags=[{Key=server,Value=invisibli}]' --no-cli-pager

sleep 5

echo "Giving the instance 30 seconds to get provisioned"

sleep 30

# get the instance ID of the new EC2 instance
aws ec2 describe-instances --filters "Name=instance.group-name,Values='invisibli'" --output text --query 'Reservations[*].Instances[*].InstanceId' > instanceid.txt

#make the instance id a variable
iid=$(cat instanceid.txt)

#allocate a elastic IP & describe it
aws ec2 allocate-address --tag-specifications 'ResourceType=elastic-ip,Tags=[{Key=server,Value=invisibli}]'
aws ec2 describe-addresses --filters Name=tag:server,Values=invisibli  --output text  > eip.txt

#define elastic as a variable
grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' eip.txt > eip2.txt
eip=$(cat eip2.txt)

# then associate it with the made ec2
aws ec2 associate-address --instance-id $iid --public-ip $eip
sleep 2

# get the public DNS of the new EC2 instance
# aws ec2 describe-instances --filters "tag-key=server,Value=invisibli" --query '[dns-name]' --output test > pdns.txt
# make the publicdns a variable
#pdns=$(cat pdns.txt)

# Making the next script runnable
chmod +x script.sh

# Pulling ssh keys to local machine, connecting to new Ec2 instance, and running the autoinstaller for the ec2 instance
sleep 2
scp -i invisibli.pem script.sh ubuntu@$eip:/home/ubuntu
sleep 2
ssh -t -i invisibli.pem ubuntu@$eip 'sudo ./script.sh'
wait

#cleanup .txt files used to define variables
rm eip2.txt
rm eip.txt
rm instanceid.txt
rm deleteid.txt

#offer download of opnsense iso if wanted
while true; do
    read -p "Do you wish to download the OPNsense iso to make a local machine? (y/n) " yn
    case $yn in
        [Yy]* ) curl -l https://mirror.sfo12.us.leaseweb.net/opnsense/releases/22.1/OPNsense-22.1-OpenSSL-vga-amd64.img.bz2 > opnsense.img.bz2; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo 'Make sure you have balena etcher or another image to usb drive writer utility!'

sleep 5

echo 'Make sure you have balena etcher or another image to usb drive writer utility!'

sleep 5

#Ta-da!
echo "End of script!"
