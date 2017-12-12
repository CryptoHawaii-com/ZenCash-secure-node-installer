#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt -y -o Acquire::ForceIPv4=true update
apt-get -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
apt -y install apt-transport-https ca-certificates curl software-properties-common git pwgen lsb-release

adduser --disabled-password --gecos "" zencash 
usermod -g sudo zencash

echo "zencash ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

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

su zencash

echo 'deb https://zencashofficial.github.io/repo/ '$(lsb_release -cs)' main' | sudo tee --append /etc/apt/sources.list.d/zen.list
gpg --keyserver ha.pool.sks-keyservers.net --recv 219F55740BBF7A1CE368BA45FB7053CE4991B669
gpg --export 219F55740BBF7A1CE368BA45FB7053CE4991B669 | sudo apt-key add -

sudo apt-get update
sudo apt-get install zen
zen-fetch-params

zend

USERNAME=$(pwgen -s 16 1)
PASSWORD=$(pwgen -s 64 1)
cat <<EOF > ~/.zen/zen.conf
rpcuser=$USERNAME
rpcpassword=$PASSWORD
rpcport=18231
rpcallowip=127.0.0.1
server=1
daemon=1
listen=1
txindex=1
logtimestamps=1
### testnet config
#testnet=1
EOF

zen-cli getinfo


