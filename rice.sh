#!/bin/bash
# Script to "rice" (either Unity or i3wm)
# Mattia Racca

read -p 'Do you want Paper-Icon? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo add-apt-repository ppa:snwh/pulp
  sudo apt update && sudo apt install paper-icon-theme
fi

read -p 'Do you want Materia-Gtk? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt update && sudo apt install materia-gtk-theme
fi

if [ $DESKTOP_SESSION == "i3" ]; then
  echo -e "\n===== I3WM =====\n"
  # feh for wallpaper
  sudo apt install feh
  # lxappearance to change themes, icons, system fonts...
  sudo apt install lxappearance
  # compton for componsition...
  sudo apt install compton
  # rofi as a sane dmenu alternative
  sudo apt install rofi
  # polybar as a sane i3bar alternative
  sudo apt install polybar
  echo -e "\n===== Now you can stow the related stuff! =====\n"
fi
