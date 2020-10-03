#!/bin/bash

echo "Getting basic utils"
sudo apt install -y tmux screen vim build-essential exfat-utils htop ncdu samba samba-common-bin hdparm

echo "Setting up pihole"
curl -sSL https://install.pi-hole.net | sudo bash

echo "Setting up docker"
curl -fsSL https://get.docker.com | sudo bash
sudo usermod -aG docker pi
sudo usermod -aG docker root

sudo echo "tmpfs /tmp     tmpfs defaults,noatime,nosuid,size=100m           0 0" >> /etc/fstab
sudo echo "tmpfs /var/tmp tmpfs defaults,noatime,nosuid,size=30m            0 0" >> /etc/fstab
sudo echo "tmpfs /var/log tmpfs defaults,noatime,nosuid,mode=0755,size=100m 0 0" >> /etc/fstab
sudo echo "tmpfs /var/run tmpfs defaults,noatime,nosuid,mode=0755,size=2m   0 0" >> /etc/fstab

sudo mkdir /media/SJ_EXT/
SJ_UUID=`sudo blkid  | grep "S_AJ_EXT2"  | sed 's|.*PARTUUID="\(\S.*\)".*|\1|g'`
sudo echo "PARTUUID=$(SJ_UUID) /media/SJ_EXT/  exfat defaults,auto,umask=000,users,rw 0 0" >> /etc/fstab
sudo mount -a

sudo vim /etc/samba/smb.conf
sudo smbpasswd -a pi
sudo echo "[pishare]" >> /etc/samba/smb.conf
sudo echo "path = /media/SJ_EXT" >> /etc/samba/smb.conf
sudo echo "writeable=Yes" >> /etc/samba/smb.conf
sudo echo "create mask=0777" >> /etc/samba/smb.conf
sudo echo "directory mask=0777" >> /etc/samba/smb.conf
sudo echo "public=no" >> /etc/samba/smb.conf
sudo systemctl restart smbd

sudo hdparm -y /dev/sda
sudo hdparm -B127 /dev/sda
sudo echo "/dev/sda {" >> /etc/hdparm.conf
sudo echo "write_cache = on" >> /etc/hdparm.conf
sudo echo "spindown_time = 120" >> /etc/hdparm.conf
sudo echo "}" >> /etc/hdparm.conf

sudo apt-get remove --purge wolfram-engine libreoffice chromium-browser x11-common -y
sudo apt-get remove --purge wolfram-engine libreoffice -y
sudo apt-get remove --auto-remove --purge libx11-.* -y
sudo apt-get autoremove  -y

git config --global user.email "kannan.ajay@gmail.com"
git config --global user.name "Ajaykumar Kannan"

git clone https://github.com/markgandolfo/git-bash-completion.git ~/src/git-bash-completion
git clone git@github.com:ajaykumarkannan/bash_utils.git ~/src/bash_utils/

cd ~/
rm ~/.bashrc
for file in ~/src/bash_utils/.*
do
  if [ -f $file ]; then
    ln -s $i
  fi
done
