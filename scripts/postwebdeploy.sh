#!/bin/bash
while inotifywait -e modify /var/www/secnodeinfo.txt; do
	FQDN=$(sed -n '2p' /var/www/secnodeinfo.txt)
	TADDR=$(sed -n '3p' /var/www/secnodeinfo.txt)
	apt-get -y update
	apt-get -y install software-properties-common
	add-apt-repository -y ppa:certbot/certbot
	apt-get -y update
	apt-get -y install python-certbot-apache 
	break 
done
