#!/bin/bash
# A Simple Install Script for Ubuntu 16.04
# Mattia Racca

echo ===== This script installs things I usually need =====

read -p 'Gonna sudo apt update here. Fine? [y/n]' answer
if [ "$answer" = y -o -z "$answer" ];then
  sudo apt update
fi

echo ===== Terminal related stuff =====

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

echo ===== GUI related stuff =====

read -p 'Do you want unity-tweak tool? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install unity-tweak-tool
fi
echo Probably want to get the paper-icon-theme!

# TODO: add install for Skype, GIMP, Inkscape, Slack

echo ===== Done installing main tools =====
echo ===== git account setup =====

read -p 'What is your git account? ' username
read -p 'What is your git email? ' email

if [ -z "$username" -o -z "$email" ];then
  echo Not configuring git account...
else
  echo git account configured
  git config --global user.name "$username"
  git config --global user.email $email
fi

read -p 'Do you want gitg? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install gitg
fi

echo ===== Done with git related setup! =====
echo ===== Now we can stow the dotfiles =====

read -p 'We need stow. Fine? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install stow
else
  echo Well, no dotfiles then...
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
  echo setting gedit up
  dconf load /org/gnome/gedit/ < gedit/gedit.dconf
fi

read -p 'git-completion settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  echo setting git-completion up
  stow git-completion
fi

read -p 'gnome-terminal settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  echo setting gnome-terminal up
  code=`dconf dump /org/gnome/terminal/legacy/profiles:/ | head -n 1 | sed 's/^..//' | sed s'/.$//'`
  code="/org/gnome/terminal/legacy/profiles:/:$code/"
  dconf load $code < gnome-terminal/standard.dconf
fi

if [ "$terminator" = "y" -o -z "$terminator" ];then
  read -p 'terminator settings? [y/n]: ' answer
  if [ "$answer" = "y" -o -z "$answer" ];then
    echo setting terminator up
    stow terminator
  fi
else
  echo Skipping terminator settings...
fi
