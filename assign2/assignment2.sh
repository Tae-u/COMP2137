#!/bin/bash

#Network
lannetnum=192.168.16
ipaddress=192.168.16.21
dnsip=192.168.16.1
containermgmtip=172.16.1.10

sed -i "s/* server1/'$ipaddress' server1/g" /etc/hosts

rm -f /etc/netplan/50-cloud-init.yaml
cat > /etc/netplan/51-assignment2.yaml <<EOF
network:
    version: 2
    ethernets:
        eth0:
            addresses: [$ipaddress/24]
            routes:
              - to: default
                via: $lannetnum.1
            nameservers:
                addresses: [$dnsip]
                search: [home.arpa, localdomain]
        eth1:
            addresses: [$containermgmtip/24]
EOF


#Software
apt-get update
if ! systemctl is-active --quiet apache2 2>/dev/null; then
        apt-get install -y apache2
fi
if ! systemctl is-active --quiet squid 2>/dev/null; then
        apt-get install -y squid
fi

sed -i 's/PasswordAuthentication yes/PasswordAuthentication no /g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes /g' /etc/ssh/sshd_config
sed -i 's/Listen 80/Listen 80\nListen 443/g' /etc/apache2/ports.conf
sed -i 's/#http_port 3128/http_port 3128/g' /etc/squid/squid.conf

#Firewall
ufw enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 3128/tcp


#User
#dennis
useradd -m -s /bin/bash dennis
mkdir /home/dennis/.ssh
chmod 700 "/home/dennis/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/dennis/.ssh/"
cp "/home/dennis/.ssh/id_ed25519.pub" "/home/dennis/.ssh/authorized_keys"
chmod 600 "/home/dennis/.ssh/authorized_keys"
usermod -aG sudo dennis
cat ~/.ssh/authorized_keys >> /home/dennis/.ssh/authorized_keys
#aubrey
useradd -m -s /bin/bash aubrey
mkdir /home/aubrey/.ssh
chmod 700 "/home/aubrey/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/aubrey/.ssh/"
cp "/home/aubrey/.ssh/id_ed25519.pub" "/home/aubrey/.ssh/authorized_keys"
chmod 600 "/home/aubrey/.ssh/authorized_keys"
#captain
useradd -m -s /bin/bash captain
mkdir /home/captain/.ssh
chmod 700 "/home/captain/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/captain/.ssh/"
cp "/home/captain/.ssh/id_ed25519.pub" "/home/captain/.ssh/authorized_keys"
chmod 600 "/home/captain/.ssh/authorized_keys"
#snibbles
useradd -m -s /bin/bash snibbles
mkdir /home/snibbles/.ssh
chmod 700 "/home/snibbles/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/snibbles/.ssh/"
cp "/home/snibbles/.ssh/id_ed25519.pub" "/home/snibbles/.ssh/authorized_keys"
chmod 600 "/home/snibbles/.ssh/authorized_keys"
#brownie
useradd -m -s /bin/bash brownie
mkdir /home/brownie/.ssh
chmod 700 "/home/brownie/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/brownie/.ssh/"
cp "/home/brownie/.ssh/id_ed25519.pub" "/home/brownie/.ssh/authorized_keys"
chmod 600 "/home/brownie/.ssh/authorized_keys"
#scooter
useradd -m -s /bin/bash scooter
mkdir /home/scooter/.ssh
chmod 700 "/home/scooter/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/scooter/.ssh/"
cp "/home/scooter/.ssh/id_ed25519.pub" "/home/scooter/.ssh/authorized_keys"
chmod 600 "/home/scooter/.ssh/authorized_keys"
#sandy
useradd -m -s /bin/bash sandy
mkdir /home/sandy/.ssh
chmod 700 "/home/sandy/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/sandy/.ssh/"
cp "/home/sandy/.ssh/id_ed25519.pub" "/home/sandy/.ssh/authorized_keys"
chmod 600 "/home/sandy/.ssh/authorized_keys"
#perrier
useradd -m -s /bin/bash perrier
mkdir /home/perrier/.ssh
chmod 700 "/home/perrier/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/perrier/.ssh/"
cp "/home/perrier/.ssh/id_ed25519.pub" "/home/perrier/.ssh/authorized_keys"
chmod 600 "/home/perrier/.ssh/authorized_keys"
#cindy
useradd -m -s /bin/bash cindy
mkdir /home/cindy/.ssh
chmod 700 "/home/cindy/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/cindy/.ssh/"
cp "/home/cindy/.ssh/id_ed25519.pub" "/home/cindy/.ssh/authorized_keys"
chmod 600 "/home/cindy/.ssh/authorized_keys"
#tiger
useradd -m -s /bin/bash tiger
mkdir /home/tiger/.ssh
chmod 700 "/home/tiger/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/tiger/.ssh/"
cp "/home/tiger/.ssh/id_ed25519.pub" "/home/tiger/.ssh/authorized_keys"
chmod 600 "/home/tiger/.ssh/authorized_keys"
#yoda
useradd -m -s /bin/bash yoda
mkdir /home/yoda/.ssh
chmod 700 "/home/yoda/.ssh"
cp ~/.ssh/id_ed25519.pub "/home/yoda/.ssh/"
cp "/home/yoda/.ssh/id_ed25519.pub" "/home/yoda/.ssh/authorized_keys"
chmod 600 "/home/yoda/.ssh/authorized_keys"

netplan apply
