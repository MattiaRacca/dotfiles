#!/bin/bash
# A Simple Install Script for Ubuntu 16.04
# Mattia Racca

echo -e "===== This script installs things I usually need =====\n"

read -p 'Gonna sudo apt update here. Fine? [y/n]' answer
if [ "$answer" = y -o -z "$answer" ];then
  sudo apt update
fi

echo -e "\n===== Terminal related stuff =====\n"

read -p 'Do you want vim? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install vim
fi

read -p 'Do you want terminator? [y/n]: ' terminator
if [ "$terminator" = "y" -o -z "$terminator" ];then
  sudo apt install terminator
fi

read -p 'Do you want tree command? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install tree
fi

read -p 'Do you want ssh command? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install openssh-server
fi

echo -e "\n===== GUI related stuff =====\n"

read -p 'Do you want unity-tweak tool? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install unity-tweak-tool
  echo Probably want to get the paper-icon-theme!
fi

echo -e "\n===== Work related stuff like ROS, TeX and Slack =====\n"

read -p 'Do you want ROS Kinetic? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
  sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
  sudo apt update
  sudo apt install ros-kinetic-desktop-full
  sudo rosdep init
  rosdep update
fi

read -p 'Do you want Jupyter Notebook? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  python -m pip install --upgrade pip
  python -m pip install jupyter
  python -m pip install jupyterthemes
fi

read -p 'Do you want to personalize Jupyter? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  jt -t grade3 -fs 95 -tfs 11 -nfs 115 -cellw 88%
fi

read -p 'Do you want LaTeX? (WARNING: TAKES AGES) [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install texlive-full
  # TODO: this needs to be tested
fi

read -p 'Do you want Skype? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo snap install skype --classic
fi

read -p 'Do you want Slack? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo snap install slack --classic
fi

# TODO: add install for GIMP, Inkscape

echo -e "\n===== Done installing main tools =====\n"
echo -e "===== GIT account setup =====\n"

read -p 'Want to set up the git account? [y/n]' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  read -p 'What is your git account? ' username
  read -p 'What is your git email? ' email

  if [ -z "$username" -o -z "$email" ];then
    echo Not configuring git account...
  else
    echo git account configured
    git config --global user.name "$username"
    git config --global user.email $email
  fi
fi

read -p 'Do you want gitg? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install gitg
fi

echo -e "\n===== Done with git related setup! =====\n"
echo -e "===== Now we can stow the dotfiles =====\n"

read -p 'We need stow. Fine? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install stow
else
  echo "Well, no dotfiles then..."
  exit 2
fi

read -p 'Stow bash files? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  rm ~/.bashrc
  rm ~/.bash_logout
  stow bash
fi

read -p 'gedit settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  dconf load /org/gnome/gedit/ < gedit/gedit.dconf
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

echo -e "\n===== Done with stowing! =====\n"

read -p 'Do you want the paper theme? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  cd /home/$USER/Documents
  git clone https://github.com/snwh/paper-gtk-theme.git
  source paper-gtk-theme/install-gtk-theme.sh
  cd /home/$USER
fi
