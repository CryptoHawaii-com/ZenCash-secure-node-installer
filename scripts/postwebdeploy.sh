#!/bin/bash
while inotifywait -e modify /var/www/secnodeinfo.txt; do
	FQDN=$(sed -n '2p' /var/www/secnodeinfo.txt)
	TADDR=$(sed -n '3p' /var/www/secnodeinfo.txt)
	apt install socat
	cd /root 
	git clone https://github.com/Neilpang/acme.sh.git
	cd acme.sh
	./acme.sh --install
	./acme.sh --issue --standalone -d $FQDN 

	break 
done
