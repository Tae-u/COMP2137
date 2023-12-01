#!/bin/bash -x

#target1-mgmt
sudo -- sh -c "echo 192.168.16.3 loghost >> /etc/hosts"
sudo -- sh -c "echo 192.168.16.4 webhost >> /etc/hosts"
ssh remoteadmin@target1-mgmt "hostnamectl set-hostname loghost"
ssh remoteadmin@target1-mgmt "sed -i 's/192.168.16.10 target1/192.168.16.10 loghost/g' /etc/hosts"
ssh remoteadmin@target1-mgmt "ip addr add 192.168.16.3/24 broadcast 192.168.16.255 dev eth0"
ssh remoteadmin@target1-mgmt "ip addr del 192.168.16.10/24 dev eth0"
ssh remoteadmin@target1-mgmt "sed -i 's/192.168.16.10 loghost/192.168.16.3 loghost/g' /etc/hosts"
ssh remoteadmin@target1-mgmt "echo 192.168.16.4 webhost >> /etc/hosts"
ssh remoteadmin@target1-mgmt "ufw allow 514/udp && ufw allow 22/tcp && ufw allow 80/tcp && ufw allow 443/tcp && ufw enable"
ssh remoteadmin@target1-mgmt "sed -i 's/#module(load=\"imudp\")/module(load=\"imudp\")/g' /etc/rsyslog.conf"
ssh remoteadmin@target1-mgmt "sed -i 's/#input(type=\"imudp\" port=\"514\")/input(type=\"imudp\" port=\"514\")/g' /etc/rsyslog.conf"
ssh remoteadmin@target1-mgmt "systemctl restart rsyslog"

#target2-mgmt
ssh remoteadmin@target2-mgmt "hostnamectl set-hostname webhost"
ssh remoteadmin@target2-mgmt "sed -i 's/192.168.16.11 target2/192.168.16.11 webhost/g' /etc/hosts"
ssh remoteadmin@target2-mgmt "ip addr add 192.168.16.4/24 broadcast 192.168.16.255 dev eth0"
ssh remoteadmin@target2-mgmt "ip addr del 192.168.16.11/24 dev eth0"
ssh remoteadmin@target2-mgmt "sed -i 's/192.168.16.11 webhost/192.168.16.4 webhost/g' /etc/hosts"
ssh remoteadmin@target2-mgmt "echo 192.168.16.3 loghost >> /etc/hosts"
ssh remoteadmin@target2-mgmt "ufw allow 514/udp && ufw allow 22/tcp && ufw allow 80/tcp && ufw allow 443/tcp && ufw enable"
ssh remoteadmin@target2-mgmt "apt-get update"
ssh remoteadmin@target2-mgmt "apt-get install -y apache2"
ssh remoteadmin@target2-mgmt "echo *.*@loghost >> /etc/rsyslog.conf"
ssh remoteadmin@target2-mgmt "systemctl restart rsyslog"

ssh remoteadmin@loghost grep webhost /var/log/syslog
