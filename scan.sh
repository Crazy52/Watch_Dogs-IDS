#!/bin/bash
clear
echo .____________________________.
echo ! Intrusion Detection System !
echo !----------------------------!
ip=$(curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
echo "IP:" $ip
echo Listing Availible Interfaces
echo ----
ifconfig -a | sed 's/[ \t].*//;/^$/d'
echo ----
read -p "Select an Interface [eth0]: " iface
iface=${iface:-eth0}
read -p "Save to File (y/n)?" save
case "$save" in
  y|Y ) write="-w " && file=$(date +%g%m%d_%H%M%S.pcap) && touch $file && echo Writing to $file;;
  * ) write="" && file="" && echo "Writing Disabled";;
esac
echo Starting IDS on $iface
tshark -i $iface -n -P -f "dst host $ip and udp src port 3658 and udp dst port not 11005" $write $file