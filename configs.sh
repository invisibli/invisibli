#!/bin/bash

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

API_PRIVACY_MODE=false" > setupVars.conf

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

UNATTUPG=1" > setupVars.conf

