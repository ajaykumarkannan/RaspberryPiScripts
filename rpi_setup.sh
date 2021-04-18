#!/bin/bash

echo "Getting basic utils"
sudo apt install -y tmux screen vim build-essential exfat-utils htop ncdu samba samba-common-bin hdparm unbound nload

git clone https://github.com/markgandolfo/git-bash-completion.git ~/src/git-bash-completion
git clone git@github.com:ajaykumarkannan/bash_utils.git ~/src/bash_utils/

cd ~/
rm ~/.bashrc
for file in ~/src/bash_utils/.*
do
  if [ -f $file ]; then
    ln -s $file
  fi
done

if [ `which pihole` ]; then
	echo "pihole already installed, skipping"
else
	echo "Setting up pihole"
	curl -sSL https://install.pi-hole.net | sudo bash
fi

if [ `which docker` ]; then
	echo "Docker already installed, skipping"
else
	echo "Setting up docker"
	curl -fsSL https://get.docker.com | sudo bash
	sudo usermod -aG docker pi
	sudo usermod -aG docker root
fi


sudo apt-get remove --auto-remove --purge wolfram-engine libreoffice chromium-browser x11-common libx11-.* -y
sudo apt-get autoremove  -y
sudo apt-get autoclean  -y

