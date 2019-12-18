# This script should set up iSPRESSO environment.  Only prerequisite is enabling network access, and downloading pyspresso project from 
# bitbucket, and moving pyspresso contents to /var/www

# change ownership
sudo chown pi /var/www -R
sudo chgrp pi /var/www -R

#  set up init script
sudo cp /var/www/initscript/ispresso /etc/init.d/
sudo chmod +x /etc/init.d/ispresso
sudo update-rc.d ispresso defaults

sudo apt-get -y update

# install ZeroConfig
sudo apt-get -y install avahi-daemon

# set up Python
sudo apt-get -y install python-dev python-setuptools python-pip git
sudo pip install web.py
sudo pip install simplejson
sudo easy_install -U distribute

# enable i2c (for LCD screen)
sudo apt-get -y install python-smbus

#  create a kernel module config file 
sudo touch /etc/modprobe.d/i2c.conf
echo 'install i2c-bcm2708 /bin/true' | sudo tee /etc/modprobe.d/i2c
echo 'install i2c-dev /bin/true' | sudo tee --append /etc/modprobe.d/i2c

sudo touch /etc/modprobe.d/onewire.conf
echo 'install w1-gpio /bin/true' | sudo tee /etc/modprobe.d/onewire
echo 'install w1-therm /bin/true' | sudo tee --append  /etc/modprobe.d/onewire

# load kernel modules 
sudo modprobe i2c-bcm2708
sudo modprobe i2c-dev

sudo modprobe w1-gpio
sudo modprobe w1-therm

# add crontab entries
sudo touch /etc/cron.d/autoupdate
echo "0 0 * * 0 pi /var/www/update/autoupdate.py > /var/log/autoupdate.log" | sudo tee /etc/cron.d/autoupdate

sudo touch /etc/cron.d/wificheck
echo "*/5 * * * * root /var/www/scripts/WiFi_Check > /var/log/wificheck.log" | sudo tee /etc/cron.d/wificheck

#enable smartconnect
sudo cp /var/www/setup/wifi_driver/hostapd /usr/local/bin/hostapd
sudo chown root /usr/local/bin/hostapd
sudo chgrp root /usr/local/bin/hostapd
sudo chmod 755 /usr/local/bin/hostapd
sudo chmod +x /usr/local/bin/hostapd

sudo cp /var/www/setup/hostapd.init /etc/init.d/hostapd
sudo chmod +x /etc/init.d/hostapd
sudo update-rc.d hostapd defaults
sudo mkdir /etc/hostapd/
sudo cp /var/www/setup/hostapd.conf /etc/hostapd/hostapd.conf 
sudo apt-get -y install dnsmasq

sudo service hostapd stop
sudo service dnsmasq stop

# crypto stuff to connect to AWS GW securely
sudo apt-get -y --force-yes install libffi-dev
sudo pip install urllib3 six pyopenssl ndg-httpsclient pyasn1 cryptography requests

# enable w1 (one wire) in Device Tree
if grep w1-gpio /boot/config.txt ; then echo 'w1-gpio already exist in boot config';  else sudo echo 'dtoverlay=w1-gpio' | sudo tee --append /boot/config.txt ; fi

# turn off sleepy wifi
touch /etc/modprobe.d/8192cu.conf 
echo "options 8192cu rtw_power_mgnt=0" | sudo tee /etc/modprobe.d/8192cu.conf

cd ..

sudo service ispresso start

