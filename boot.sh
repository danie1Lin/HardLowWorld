#!/usr/bin/env bash
sudo su -
apt-get update && apt-get -y install make nasm gcc
cd /vagrant

### compile HelloOS
make
cp HelloOS.bin /boot/.

### Set grub config
sed -i 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=HelloOS/' "/etc/default/grub"
#sudo sed -i 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=30/' "/etc/default/grub"
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="text"/' "/etc/default/grub"
update-grub

### Setting the HelloOS boot config
export SET_ROOT_CMD=$(grep -oe "set root='lvmid/.\\+$" /boot/grub/grub.cfg | head -n 1) 
# finding the root in original grub.cfg
# It will be like `set root='lvmid/6Q0MIB-cjFf-M7QJ-c1QS-8u2l-uDtq-kQU2A5/QWqJLu-rsOL-QFjT-AqJp-OqqW-Fq6g-QYRkA2'`, it mean the device where `/boot` locates.
envsubst < ./grub.cfg >> /boot/grub/grub.cfg
cat /boot/grub/grub.cfg

### End
shutdown now
