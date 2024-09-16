#!/bin/bash
# A simple install script for Raspberry OS
# Mattia Racca

echo -e "\n===== Fresh installation =====\n"
sudo apt update
sudo apt install stow

read -p 'stow bash files? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  rm ~/.bashrc
  rm ~/.bash_logout
  stow bash
fi

read -p 'Do you want vim? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install vim
  stow vim
fi

read -p 'Do you want git account? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  stow git
fi

read -p 'Do you want Docker? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
	# not sure this export is needed, but Raspberry Pi OS (64-bit) is Debian 12 (bookworm)
    export VERSION_CODENAME=bookworm
	# Add Docker's official GPG key:
	sudo apt-get update
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker $USER

	# Create docker group and add user to group
	sudo groupadd docker
	sudo usermod -aG docker $USER
fi

read -p 'Do you want samba? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
	sudo apt install samba
fi

read -p 'Do you want Mopidy? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
	sudo wget -q -O /etc/apt/keyrings/mopidy-archive-keyring.gpg https://apt.mopidy.com/mopidy.gpg
	sudo wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/$VERSION_CODENAME.list
	sudo apt update
	sudo apt install mopidy mopidy-mpd mopidy-local
fi