#!/bin/bash
while inotifywait -e modify /var/www/secnodeinfo.txt; do
	FQDN=$(sed -n '2p' /var/www/secnodeinfo.txt)
	TADDR=$(sed -n '3p' /var/www/secnodeinfo.txt)
	EMAIL=$(sed -n '4p' /var/www/secnodeinfo.txt)
	systemctl stop apache2
	apt-get -y install socat
	cd /root
	git clone https://github.com/Neilpang/acme.sh.git
	cd acme.sh
	./acme.sh --install
	echo $FQDN
	/root/.acme.sh/acme.sh --issue --standalone -d $FQDN 
	(crontab -l 2>/dev/null; echo "6 0 * * * /root/.acme.sh/acme.sh --cron --home /root/.acme.sh") | crontab -
	cp /root/.acme.sh/$FQDN/ca.cer /usr/local/share/ca-certificates/ca.crt
	update-ca-certificates
	cp /root/.acme.sh/$FQDN/$FQDN.cer /home/zencash
	cp /root/.acme.sh/$FQDN/$FQDN.key /home/zencash
	chown -R zencash.zencash /home/zencash
	sudo -i -u zencash zen-cli stop
	echo "tlscertpath=/home/zencash/$FQDN.cer" >> /home/zencash/.zen/zen.conf 
	echo "tlskeypath=/home/zencash/$FQDN.key" >> /home/zencash/.zen/zen.conf
	sudo -i -u zencash zend
	sleep 1
	sudo -i -u zencash zen-cli getnetworkinfo | grep tls_cert_verified
	echo $TADDR > /tmp/info.txt
	echo $EMAIL >> /tmp/info.txt
	node setup.js < /tmp/info.txt
	node app.js
	cd /home/zencash/zencash/secnodetracker
	npm install pm2 -g
	pm2 start app.js --name securenodetracker
	pm2 startup
	apt-get -y install monit
	cd /home/zencash
	wget https://raw.githubusercontent.com/CryptoHawaii-com/ZenCash-secure-node-installer/master/scripts/zen_node.sh
	chmod 755 zen_node.sh
	echo "set httpd port 2812" >> /etc/monit/monitrc
	echo "use address localhost" >> /etc/monit/monitrc
	echo "allow localhost" >> /etc/monit/monitrc
	echo "check process zend with pidfile /home/zencash/.zen/zen_node.pid"  >> /etc/monit/monitrc
	echo "start program = \"/home/zencash/zen_node.sh start\" with timeout 60 seconds" >> /etc/monit/monitrc
	echo "stop program = \"/home/zencash/zen_node.sh stop\"" >> /etc/monit/monitrc
	monit reload
	monit start zend
	break 
done
