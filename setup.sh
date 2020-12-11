#!/bin/bash
# A simple install script for Ubuntu > 16.04
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

read -p 'Do you want terminator? [y/n]: ' terminator
if [ "$terminator" = "y" -o -z "$terminator" ];then
  sudo apt install terminator
fi

read -p 'Do you want tree? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install tree
fi

read -p 'Do you want ssh? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install openssh-server
fi

read -p 'Do you want grub-customizer? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo add-apt-repository ppa:danielrichter2007/grub-customizer
  sudo apt update
  sudo apt install grub-customizer
fi

read -p 'Do you want Dropbox? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  firefox https://www.dropbox.com/install-linux
  echo -e "\n Add @reboot ~/Documents/Miscellanea/dropbox-dist/dropboxd to crontab -e\n"
  read -p 'Done? [y/n]: ' otheranswer
  sudo apt install nautilus-dropbox
fi

read -p 'Do you want Skype? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo snap install skype --classic
fi

read -p 'Do you want Nordvpn? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  firefox https://support.nordvpn.com/Connectivity/Linux/1325531132/Installing-and-using-NordVPN-on-Debian-Ubuntu-Elementary-OS-and-Linux-Mint.htm
  read -p 'Done [y/n] ' otheranswer
fi


echo -e "\n===== Work related stuff like ROS, LaTeX and Slack =====\n"

read -p 'Do you want ROS Melodic? [y/n]: ' melodic
if [ "$melodic" = "y" -o -z "$melodic" ];then
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
  sudo apt update
  sudo apt install ros-kinetic-desktop-full
  sudo rosdep init
  rosdep update
else
  read -p 'What about ROS Kinetic? [y/n]: ' kinetic
  if [ "$kinetic" = "y" -o -z "$kinetic" ];then
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    sudo apt update
    sudo apt install ros-kinetic-desktop-full
    sudo rosdep init
    rosdep update
  fi
fi

read -p 'Do you want Jupyter Notebook? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install python-pip
  python -m pip install --upgrade pip
  python -m pip install jupyterthemes
  sudo apt install jupyter-core
  sudo apt install jupyter-notebook
fi

read -p 'Do you want to personalize Jupyter? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  jt -t grade3 -fs 95 -tfs 11 -nfs 115 -cellw 88%
  # if this command fails search for where jt is with 'find / -name "jt"'
  # then sudo + "the path where 'jt' lies" + command line options
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

read -p 'Do you want Slack? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo snap install slack --classic
fi

read -p 'Do you want Zoom? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  wget -O Downloads/zoom.deb https://zoom.us/client/latest/zoom_amd64.deb
  sudo snap install slack --classic
  sudo apt -f install
fi

read -p 'Do you want Zotero? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  firefox https://www.zotero.org/download/
  # to change the icon, write simply Icon=zotero in ~/.local/share/applications/zotero.desktop
fi

echo -e "===== GIT account setup =====\n"
echo -e "git account now stowable with stow git (info in .gitconfig)"

read -p 'Do you want gitg? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install gitg
fi

echo -e "===== Now we can stow the dotfiles! =====\n"

read -p 'We need stow. Fine? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install stow
else
  echo "Well, no dotfiles then..."
  exit 2
fi

read -p 'stow bash files? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  rm ~/.bashrc
  rm ~/.bash_logout
  stow bash
fi

read -p 'gedit settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  dconf load /org/gnome/gedit/ < gedit/gedit.dconf
  sudo apt install gedit-plugins
fi

read -p 'git-completion settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  stow git-completion
fi

read -p 'gnome-terminal settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  code=`dconf dump /org/gnome/terminal/legacy/profiles:/ | head -n 1 | sed 's/^..//' | sed s'/.$//'`
  code="/org/gnome/terminal/legacy/profiles:/:$code/"
  dconf load $code < gnome-terminal/standard.dconf
fi

if [ "$terminator" = "y" -o -z "$terminator" ];then
  read -p 'terminator settings? [y/n]: ' answer
  if [ "$answer" = "y" -o -z "$answer" ];then
    stow terminator
  fi
else
  echo "Skipping terminator settings..."
fi

echo "Select default terminal..."
sudo update-alternatives --config x-terminal-emulator

echo -e "\n===== Done with stowing! =====\n"
