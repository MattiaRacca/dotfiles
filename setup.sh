#!/bin/bash
# A simple install script for Ubuntu 20.04
# Mattia Racca

echo -e "===== This script installs programs I usually need =====\n"

read -p 'Gonna sudo apt update here. Fine? [y/n]' answer
if [ "$answer" = y -o -z "$answer" ];then
  sudo apt update
fi

echo -e "\n===== Terminal related stuff =====\n"

read -p 'Do you want vim? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install vim
  # curl to get the plugins with vim-plug
  sudo apt install curl
fi

read -p 'Do you want tree? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install tree
fi

read -p 'Do you want grub-customizer? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install grub-customizer
fi
read -p 'Do you want ssh? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install openssh-server
fi

read -p 'Do you want Dropbox? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
  (crontab -l ; echo "@reboot ~/.dropbox-dist/dropboxd")| crontab -
fi

read -p 'Do you want Nordvpn? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
fi

read -p 'Do you want Visual Studio Code? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo snap install --classic code
fi

echo -e "===== Now we can stow the dotfiles! =====\n"

read -p 'We need stow. Fine? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install stow
else
  echo "Well, no dotfiles then..."
  exit 2
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

read -p 'stow bash files? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  rm ~/.bashrc
  rm ~/.bash_logout
  stow bash
fi

read -p 'stow vim? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  stow vim
fi

read -p 'gedit settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  dconf load /org/gnome/gedit/ < gedit/gedit.dconf
  sudo apt install gedit-plugins
fi

read -p 'gnome terminal settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  dconf load /org/gnome/terminal/legacy/profiles:/ < ~/dotfiles/gnome-terminal/ukiyoe.dconf
  sudo apt install gedit-plugins
fi

echo -e "\n===== Done with stowing! =====\n"

echo -e "\n===== Work related stuff like Conda, ROS, LaTeX, Zoom =====\n"

read -p 'Do you want conda? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  wget -O ~/Downloads/conda.sh https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
  bash ~/Downloads/conda.sh
  stow conda
  rm ~/Downloads/conda.sh
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

