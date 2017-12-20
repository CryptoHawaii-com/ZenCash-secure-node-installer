#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt -y -o Acquire::ForceIPv4=true update
apt-get -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
apt -y install apt-transport-https ca-certificates curl software-properties-common git pwgen lsb-release apache2 php libapache2-mod-php php-mcrypt inotify-tools

adduser --disabled-password --gecos "" zencash 
usermod -g sudo zencash

fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile none swap sw 0 0" >> /etc/fstab
echo "vm.swappiness=10" >> /etc/sysctl.conf

ufw default allow outgoing
ufw default deny incoming
ufw allow ssh/tcp
ufw limit ssh/tcp
ufw allow http/tcp
ufw allow https/tcp
ufw allow 9033/tcp
ufw allow 19033/tcp
ufw logging on
ufw --force enable

apt-get -y install fail2ban
systemctl enable fail2ban
systemctl start fail2ban


echo 'deb https://zencashofficial.github.io/repo/ '$(lsb_release -cs)' main' | sudo tee --append /etc/apt/sources.list.d/zen.list
gpg --keyserver ha.pool.sks-keyservers.net --recv 219F55740BBF7A1CE368BA45FB7053CE4991B669
gpg --export 219F55740BBF7A1CE368BA45FB7053CE4991B669 | sudo apt-key add -

apt-get -y update
apt-get -y install zen
sudo -i -u zencash zen-fetch-params

sudo -i -u zencash zend

USERNAME=$(pwgen -s 16 1)
PASSWORD=$(pwgen -s 64 1)
sudo -i -u zencash echo "rpcuser=$USERNAME" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "rpcpassword=$PASSWORD" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "rpcport=18231" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "rpcallowip=127.0.0.1" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "server=1" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "daemon=1" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "listen=1" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "txindex=1" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "logtimestamps=1" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "### testnet config" >> /home/zencash/.zen/zen.conf
sudo -i -u zencash echo "#testnet=1" >> /home/zencash/.zen/zen.conf

sudo -i -u zencash zend
sleep 2s
sudo -i -u zencash zen-cli getinfo

systemctl start apache2
a2ensite default-ssl 
a2enmod ssl 
systemctl restart apache2 
rm -f /var/www/html/index.html

sudo -i -u zencash zen-cli z_getnewaddress
ZADDR=$(sudo -i -u zencash zen-cli z_listaddresses | tr -d '[] "')
echo $ZADDR > /var/www/secnodeinfo.txt
chown www-data.www-data /var/www/secnodeinfo.txt
touch /var/www/certbotsetup.txt 
chown www-data.www-data /var/www/certbotsetup.txt
cd /var/www/html
wget https://raw.githubusercontent.com/CryptoHawaii-com/ZenCash-secure-node-installer/master/webscript/index.php
wget https://raw.githubusercontent.com/CryptoHawaii-com/ZenCash-secure-node-installer/master/webscript/deploy.php
chown -R www-data.www-data /var/www/html

apt -y install npm
npm install -g n
n latest

cd /root
wget https://raw.githubusercontent.com/CryptoHawaii-com/ZenCash-secure-node-installer/master/scripts/postwebdeploy.sh
chmod 755 postwebdeploy.sh

echo "Please goto https://your.server.ip.address to complete the installation"

/root/postwebdeploy.sh &


