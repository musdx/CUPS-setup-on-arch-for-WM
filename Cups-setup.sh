#!/bin/bash

echo "Installing Cups and Extra Pakages..."

sudo pacman -S --noconfirm cups cups-filters cups-pdf cups-pk-helper libcups 
sudo systemctl start cups
sudo systemctl enable cups
echo "Installing avahi and nss-mdns for printer discovery"

sudo pacman -S --noconfirm nss-mdns avahi
sudo systemctl start avahi-daemon
sudo systemctl enable avahi-daemon

echo "Setup /etc/nsswitch.conf"
file="/etc/nsswitch.conf"
old_line="hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns"
new_line="hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns"
sudo sed -i "s|$old_line|$new_line|" "$file"

echo "Updated /etc/nsswitch.conf:"
cat "$file" | grep "hosts:"

echo "Installing system-config-printer for GUI support"
sudo pacman -S --noconfirm system-config-printer

while true; do

read -p "Do you want to install footmatic & gutenprint generic printer driver? (y/n) " yn

case $yn in 
	[yY] ) echo ok, we will proceed;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac

done

echo Installing Driver...
sudo pacman -S --noconfirm foomatic-db-nonfree-ppds foomatic-db-nonfree foomatic-db-ppds foomatic-db gutenprint foomatic-db-gutenprint-ppds

while true; do

read -p "Do you want to install samsung printer driver(This will need yay)? (y/n) " yn

case $yn in 
	[yY] ) echo ok, we will proceed;
		break;;
	[nN] ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac

done

echo Installing Driver...
sudo yay -S splix samsung-unified-driver
