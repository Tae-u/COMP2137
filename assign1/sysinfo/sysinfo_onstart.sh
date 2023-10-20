#!/bin/bash

# Variables that will replace each value corresponding to each section.
USER=$(whoami)
DATETIME=$(date)
HOSTNAME=$(hostname)
OSVERSION=$(cat /etc/issue)
OSVERSION="${OSVERSION%%LTS*}"
UPTIME=$(uptime -p)
MODELNAME=$(cat /proc/cpuinfo | grep "model name" | uniq)
MODELNAME="${MODELNAME#*:}"
CPUSPEED=$(cat /proc/cpuinfo | grep "cpu MHz" | uniq)
CPUSPEED="CUR:${CPUSPEED#*:} Mhz"
MAXSPEED=$(sudo dmidecode | grep "Max Speed" | uniq)
MAXSPEED=" MAX:${MAXSPEED#*:} Mhz"
CPUSPEED="${CPUSPEED},${MAXSPEED}"
RAMSIZE=$(free -m | grep ^Mem | awk '{print $2}')
RAMSIZE="${RAMSIZE} MB"
DISKMODEL=$(sudo fdisk -l | grep "Disk model" | uniq)
DISKMODEL="${DISKMODEL#*:}"
DISKSDA=$(lsblk | grep ^sda | awk '{print $4}')
DISKSDB=$(lsblk | grep ^sdb | awk '{print $4}')
DISK="MODEL:${DISKMODEL}, MAIN DISK SPACE:${DISKSDA}, ADDED DISK SPACE:${DISKSDB}"
VIDEOCARD=$(lspci | grep -i VGA)
VIDEOCARD="${VIDEOCARD#*controller:}"
FQDN=$(hostname --fqdn)
HOSTADDR=$(ip addr | grep -E 'inet.*ens33' | awk '{print $2}')
CIDR=$HOSTADDR
HOSTADDR="${HOSTADDR%???}"
GATEWAY=$(ip route | grep default | awk '{print $3}')
DNS=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
INTERFACE=($(ip link | grep -E '[0-9]:......:' | awk '{print $2}' | awk '{print substr($0, 1, length($0)-1)}'))
LOGIN=$(who -q | head -1)
REGTEXT="FREE SPACE FOR LOCAL FILESYSTEMS IN FORMAT: /MOUNTPOINT N"
PCOUNT=$(ps -ef | wc -l )
FREESPACE=($(df -h | grep /dev/sd | awk '{print $1, $4}'))
LISTEN=($(ss -lntu | grep LISTEN | awk '{print $5}'))
LOADAVG=$(cat /proc/loadavg)
TOTAL=$(cat /proc/meminfo | grep allocTotal | awk '{print $2}')
USED=$(cat /proc/meminfo | grep allocUsed | awk '{print $2}')
MEMFREE=`expr "$TOTAL" "-" "$USED"`
UFW=$(sudo ufw show added | grep ^ufw)


while read LINE;do
	if [[ "$LINE" == *USERNAME* ]];then
		echo $LINE | sed "s/USERNAME/$USER/g" | sed "s/DATE\/TIME/$DATETIME/g" 
	elif [[ "$LINE" == *Hostname:* ]];then
		echo $LINE | sed "s/HOSTNAME/$HOSTNAME/g"
	elif [[ "$LINE" == *OS:* ]];then
                echo $LINE | sed "s/DISTROWITHVERSION/$OSVERSION/g"
	elif [[ "$LINE" == *Uptime:* ]];then
                echo $LINE | sed "s/UPTIME/$UPTIME/g"
	elif [[ "$LINE" == *cpu:* ]];then
                echo $LINE | sed "s/PROCESSOR MAKE AND MODEL/$MODELNAME/g"
	elif [[ "$LINE" == *Speed:* ]];then
                echo $LINE | sed "s/CURRENT AND MAXIMUM CPU SPEED/$CPUSPEED/g"
	elif [[ "$LINE" == *Ram:* ]];then
                echo $LINE | sed "s/SIZE OF INSTALLED RAM/$RAMSIZE/g"
	elif [[ "$LINE" =~ Disk\(s\): ]];then
                echo $LINE | sed "s/MAKE AND MODEL AND SIZE FOR ALL INSTALLED DISKS/$DISK/g"
	elif [[ "$LINE" == *Video:* ]];then
                echo $LINE | sed "s/MAKE AND MODEL OF VIDEO CARD/$VIDEOCARD/g"
	elif [[ "$LINE" == *FQDN:* ]];then
                echo $LINE | sed "s/ FQDN/ $FQDN/g"
	elif [[ "$LINE" =~ Host\ Address: ]];then
                echo $LINE | sed "s|IP ADDRESS FOR THE HOSTNAME|$HOSTADDR|g"
	elif [[ "$LINE" =~ Gateway\ IP: ]];then
                echo $LINE | sed "s/GATEWAY ADDRESS/$GATEWAY/g"
	elif [[ "$LINE" == *Server:* ]];then
                echo $LINE | sed "s/IP OF DNS SERVER/$DNS/g"
	elif [[ "$LINE" == *InterfaceName* ]];then
                echo $LINE | sed "s|MAKE AND MODEL OF NETWORK CARD|${INTERFACE[*]}|g"
	elif [[ "$LINE" =~ IP\ Address: ]];then
                echo $LINE | sed "s|IP Address in CIDR format|$CIDR|g"
	elif [[ "$LINE" == *In:* ]];then
                echo $LINE | sed "s/USER,USER,USER.../$LOGIN/g"
	elif [[ "$LINE" =~ Disk\ Space: ]];then
		echo $LINE | sed "s|FREE SPACE FOR LOCAL FILESYSTEMS IN FORMAT: /MOUNTPOINT N|${FREESPACE[*]}|g"
	elif [[ "$LINE" == *Count:* ]];then
                echo $LINE | sed "s/N/$PCOUNT/g"
	elif [[ "$LINE" == *Averages:* ]];then
                echo $LINE | sed "s|N, N, N|$LOADAVG|g"
	elif [[ "$LINE" == *Allocation:* ]];then
                echo $LINE | sed "s/DATA FROM FREE/$MEMFREE/g"
	elif [[ "$LINE" == *Ports:* ]];then
                echo $LINE | sed "s/N, N, N, .../${LISTEN[*]}/g"
	elif [[ "$LINE" == *Rules:* ]];then
                echo $LINE | sed "s/DATA FROM UFW SHOW/$UFW/g"
	else
		echo $LINE
	fi
        
done < ~/class/COMP2137/assign1/sysinfo/tpl_sysinfo

