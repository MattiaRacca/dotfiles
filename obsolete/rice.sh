#!/bin/bash
# Script to "rice" (either Unity or i3wm)
# Mattia Racca

read -p 'Do you want Paper-Icon? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo add-apt-repository ppa:snwh/ppa
  sudo apt update && sudo apt install paper-icon-theme
fi

read -p 'Do you want Materia-Gtk? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt update && sudo apt install materia-gtk-theme
fi

read -p 'Do you want i3gaps? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo add-apt-repository ppa:kgilmer/speed-ricer
  sudo apt update && sudo apt install i3-gaps
  i3-config-wizard
  stow i3wm
  stow xresources
fi

if [ $DESKTOP_SESSION == "i3" ]; then
  echo -e "\n===== I3WM =====\n"
  # feh for wallpaper
  sudo apt install feh
  # scrot for screens (and the lock screen)
  sudo apt install scrot
  # lxappearance to change themes, icons, system fonts...
  sudo apt install lxappearance
  # compton for componsition...
  sudo apt install compton
  # rofi as a sane dmenu alternative
  sudo apt install rofi
  stow rofi
  # polybar as a sane i3bar alternative
  sudo apt install polybar
  stow polybar
  # urvxt
  sudo apt install rxvt-unicode
  stow urxvt
  # mpv
  sudo apt install mpv
  # imagemagick for the lockscreen
  sudo apt install imagemagick
  # dunst
  sudo apt install dunst
  # networkmanager_dmenu
  firefox https://github.com/firecat53/networkmanager-dmenu
  # install icomoon feather font
  echo -e "\n===== Now you can stow the related stuff! =====\n"
  # install font awesome 5
  firefox https://github.com/FortAwesome/Font-Awesome
  echo -e "Use gnome-font-viewer for the icomoon feather font (in polybar folder)"
  echo -e "and the otfs of Font-Awesome"
  # To change fonts and GTK
  echo -e "Use lxappearance for changing GTK theme and icons"
  echo -e "Remember to set Wallpaper.png and Profile.png in ~/Pictures"
  # if xbacklight doesn't work, there is light
  firefox https://github.com/haikarainen/light
fi
