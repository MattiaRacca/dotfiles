#!/bin/bash
# A simple install script for Ubuntu 20.04
# Mattia Racca

echo -e "===== This script installs programs I usually need =====\n"

read -p 'Gonna sudo apt update here. Fine? [y/n]' answer
if [ "$answer" = y -o -z "$answer" ];then
  sudo apt update
else
  echo "Well, thought luck..."
  exit 2
fi

read -p 'We need stow. Fine? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install stow
else
  echo "Well, no dotfiles then..."
  exit 2
fi

echo -e "\n===== Terminal related stuff =====\n"

read -p 'stow bash files? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  rm ~/.bashrc
  rm ~/.bash_logout
  stow bash
fi

read -p 'Do you want vim? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install vim
  # curl to get the plugins with vim-plug
  sudo apt install curl
  stow vim
fi

read -p 'Do you want tree/htop/ssh? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install tree
  sudo apt install htop
  sudo apt install openssh-server
fi

read -p 'Do you want grub-customizer? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install grub-customizer
fi

read -p 'gnome terminal settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  dconf load /org/gnome/terminal/legacy/profiles:/ < ~/dotfiles/gnome-terminal/ukiyoe.dconf
  sudo apt install gedit-plugins
fi

read -p 'Do you want Dropbox? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
  (crontab -l ; echo "@reboot ~/.dropbox-dist/dropboxd")| crontab -
  bash ~/.dropbox-dist/dropboxd
fi

read -p 'Do you want Nordvpn? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
fi

read -p 'Do you want Visual Studio Code? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  firefox https://code.visualstudio.com/docs/?dv=linux64_deb
  read -p 'Downloaded the .deb? [y/n]: ' answer
  sudo apt install ~/Downloads/code*.deb
  rm ~/Downloads/code*.deb
fi

echo -e "===== GIT account setup =====\n"
read -p 'Do you want git account? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  stow git
fi

read -p 'Do you want gitg? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install gitg
fi

read -p 'Gedit settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  dconf load /org/gnome/gedit/ < gedit/gedit.dconf
  sudo apt install gedit-plugins
fi

echo -e "\n===== Work related stuff =====\n"

read -p 'Do you want miniconda? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  wget -O ~/Downloads/conda.sh https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
  bash ~/Downloads/conda.sh
  stow conda
  rm ~/Downloads/conda.sh
fi

read -p 'Do you want Jupyter? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
    sudo apt install python3-pip
    pip install notebook
    stow jupyter
fi

read -p 'Do you want ROS Noetic? [y/n]: ' noetic
if [ "$noetic" = "y" -o -z "$noetic" ];then
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
  sudo apt update
  sudo apt install ros-noetic-desktop-full
  sudo rosdep init
  rosdep update
fi

read -p 'Do you want TeXlive-full? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install texlive-full
else
  read -p 'What about the academic TeX package? [y/n]: ' latexacc
  if [ "$latexacc" = "y" -o -z "$latexacc" ];then
    sudo apt install texlive texlive-fonts-extra texlive-science
  fi
fi

read -p 'Do you want Zoom? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  wget -O ~/Downloads/zoom.deb https://zoom.us/client/latest/zoom_amd64.deb
  sudo apt -f install ~/Downloads/zoom.deb
  rm ~/Downloads/zoom.deb
fi

read -p 'Do you want Zotero? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  firefox https://github.com/retorquere/zotero-deb
  # to change the icon, write simply Icon=zotero in ~/.local/share/applications/zotero.desktop
  read -p 'Done? [y/n] ' otheranswer
fi

