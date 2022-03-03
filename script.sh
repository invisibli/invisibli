#!/bin/bash

# Credit:
# Some lines for the pivpn and pihole installation are modified/copied from their respective repos:
# https://github.com/pivpn/pivpn
# https://github.com/pi-hole/pi-hole

apt-get -y update

wait

apt-get -y upgrade

apt-get -y install net-tools

wait 

#define IPv4 address variable for the setupVars.conf files
IP4=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

cd ~

mkdir -p /etc/pihole && cd $_

echo "WEBPASSWORD=a215bae8b5ec659b0980a76dlkds09644731cd439cab41494447a8705c22b3aa41c

PIHOLE_INTERFACE=eth0

QUERY_LOGGING=true

INSTALL_WEB=true

DNSMASQ_LISTENING=single

IPV4_ADDRESS=${IP4}/20

PIHOLE_DNS_1=1.1.1.1

PIHOLE_DNS_2=1.0.0.1

DNS_FQDN_REQUIRED=true

DNS_BOGUS_PRIV=true

DNSSEC=true

TEMPERATUREUNIT=C

WEBUIBOXEDLAYOUT=traditional

API_EXCLUDE_DOMAINS=

API_EXCLUDE_CLIENTS=

API_QUERY_LOG_SHOW=all

API_PRIVACY_MODE=false" | sudo tee setupVars.conf

cd ~

curl -L https://install.pi-hole.net | bash /dev/stdin --unattended

wait

read -r -p 'PiHole installation complete! (press any key to continue)' -n1 -s && echo ' '

read -r -p 'Go to http://pi.hole/admin/ to configure farther, or to change options (like changing your password!) (press any key to continue)' -n1 -s ; echo ' '

read -p $'Enter a desired password for pihole webconsole\n' wpwd

pihole -a -p "$wpwd"

read -r -p "The web password for the pihole has been set to $wpwd (press any key to continue)" -n1 -s && echo ' '

read -r -p 'Press any key to continue, and start Wireguard installation' -n1 -s && echo ' '

cd ~

mkdir -p /etc/wireguard && cd $_

echo "IPv4dev=eth0

IPv4addr=${IP4}

install_user=ubuntu

install_home=/home/ubuntu

VPN=wireguard

pivpnNET=10.6.0.0

subnetClass=24

ALLOWED_IPS="0.0.0.0/0, ::0/0"

pivpnMTU=1420

pivpnDEV=wg0

pivpnPORT=51820

pivpnDNS1=10.6.0.1

pivpnDNS2=

pivpnHOST=

pivpnPERSISTENTKEEPALIVE=25

UNATTUPG=1" | tee /etc/wireguard/setupVars.conf

wait

curl -L https://install.pivpn.io > install.sh

chmod +x install.sh

./install.sh --unattended setupVars.conf

wait

echo "addn-hosts=/etc/pivpn/hosts.wireguard" > /etc/dnsmasq.d/02-pivpn.conf

rm -r /etc/pivpn/hosts.wireguard && touch /etc/pivpn/hosts.wireguard.txt

ufw allow in on wg0 to any port 53 from 10.6.0.0/24

pihole -a -i local

cd ~

read -r -p 'Your server is now configured! (press any key to continue)' -n1 -s && echo ' '

read -r -p 'To create a config for a client such as phone/labtop/router type pivpn -a (press any key to continue)' -n1 -s && echo ' '

read -r -p 'To list your clients, use pivpn -c (press any key to continue)' -n1 -s && echo ' '

read -r -p 'To bring up a qr code to be able to scan a config that you have made for a phone use pivpn -qr (press any key to continue)' -n1 -s && echo ' '

read -r -p 'You have finished installation! Use pivpn/pihole --help for options for further configuration. The instance will now reboot. (press any key to exit the installation)' -n1 -s && echo ' '

reboot
