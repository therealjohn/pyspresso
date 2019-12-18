#!/bin/bash

echo `date`
echo "Starting setup.sh - setting up ispresso access point"
#sudo cp isc-dhcp-server /etc/default/

cd /var/www/setup/

sudo cp dnsmasq.conf /etc/
sudo cp dhcpd.conf /etc/dhcp
#sudo cp interfaces_setup /etc/network/interfaces
sudo cp hostapd.conf /etc/hostapd/hostapd.conf
sudo cp hostapd.init /etc/init.d/hostapd

#sudo cp 8192cu.conf /etc/modprobe.d/	#  this is now in the install script.

sudo ifdown wlan0
sleep 2

sudo ifconfig wlan0 up 192.168.1.1 netmask 255.255.255.0
sleep 2

sudo service hostapd restart
sleep 2

sudo service dnsmasq restart
sleep 2

sudo service avahi-daemon restart
