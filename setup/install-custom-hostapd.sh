wget ftp://WebUser:YbwD5pB2@209.222.7.36/cn/wlan/RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip

unzip RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip

rm RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip 

cd RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911/wpa_supplicant_hostapd/

tar -xzvf wpa_supplicant_hostapd-0.8_rtw_r7475.20130812.tar.gz 

cd wpa_supplicant_hostapd-0.8_rtw_r7475.20130812/
cd src

make 
make install

# probably have to come back and overwrite the hostapd.conf file if it was overwritten
# nope actually it looks ok.
