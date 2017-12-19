#!/bin/bash
while inotifywait -e modify /var/www/secnodeinfo.txt; do
	FQDN=$(sed -n '2p' /var/www/secnodeinfo.txt)
	TADDR=$(sed -n '3p' /var/www/secnodeinfo.txt)
	apt-get -y update
	apt-get -y install software-properties-common
	add-apt-repository -y ppa:certbot/certbot
	apt-get -y update
	apt-get -y install python-certbot-apache 
	cd /root && wget https://raw.githubusercontent.com/CryptoHawaii-com/ZenCash-secure-node-installer/master/scripts/certbotsetup.txt
	cat /root/certbotsetup.txt >> /var/www/certbotsetup.txt
	certbot --apache -d $FQDN < /var/www/certbotsetup.txt 
	break 
done
