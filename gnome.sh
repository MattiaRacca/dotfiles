#!/bin/bash
# Install script to make Gnome usable
# Mattia Racca

echo -e "===== GNOME as I like it =====\n"

read -p 'Gonna sudo apt update here. Fine? [y/n]' answer
if [ "$answer" = y -o -z "$answer" ];then
	sudo apt update
fi

echo -e "\n===== Gnome Tweaks =====\n"

read -p 'Do you want Gnome-tweaks? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
	sudo apt install gnome-tweaks
fi

echo -e "\n===== Workspaces stuff =====\n"

read -p 'Do you want Unity-style workspaces? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
	sudo apt install gnome-shell-extensions
	sudo apt install chrome-gnome-shell
	read -p 'Gonna open the page of Workspace Matrix. Fine? [y/n]: ' otheranswer
	if [ "$otheranswer" = "y" -o -z "$otheranswer" ];then
		firefox --new-window https://extensions.gnome.org/extension/1485/workspace-matrix/
	fi
	gsettings set org.gnome.shell.app-switcher current-workspace-only true
	read -p 'Gonna open the page of Put Windows. Fine? [y/n]: ' otheranswer
	if [ "$otheranswer" = "y" -o -z "$otheranswer" ];then
	  firefox --new-window https://extensions.gnome.org/extension/39/put-windows/
	fi
fi

echo -e "\n===== Theme and Icons =====\n"

read -p 'Do you want the Materia theme? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  cd /home/$USER/Documents
  git clone https://github.com/nana-4/materia-theme.git
  sudo ./materia-theme/install.sh
  cd /home/$USER
fi

echo -e "\n===== Paper icon =====\n"
read -p 'Do you want Paper Icon? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
	sudo add-apt-repository -u ppa:snwh/ppa
	sudo apt update
	sudo apt install paper-icon-theme
fi

echo -e "Remember to enable the Materia, Icons and Static Workspaces in Tweaks!\n"
