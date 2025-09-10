#!/bin/bash
# A simple install script for Ubuntu 22.04
# Mattia Racca

echo -e "\n===== Fresh installation =====\n"
sudo apt update
sudo apt install stow curl tree htop openssh-server screen

echo -e "\n===== Basic stuff =====\n"

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

read -p 'Do you want grub-customizer? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install grub-customizer
fi

echo -e "===== GNOME stuff setup =====\n"

read -p 'gnome terminal settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  dconf load /org/gnome/terminal/legacy/profiles:/ < ~/dotfiles/gnome-terminal/ukiyoe.dconf
fi

read -p 'Gedit settings? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  dconf load /org/gnome/gedit/ < gedit/gedit.dconf
  sudo apt install gedit-plugins
fi

echo -e "===== Personal tools =====\n"

read -p 'Do you want Dropbox? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
  (crontab -l ; echo "@reboot ~/.dropbox-dist/dropboxd")| crontab -
  bash ~/.dropbox-dist/dropboxd
fi

echo -e "===== SSH =====\n"

read -p 'stow ssh? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  stow ssh
fi

read -p 'create SSH key for work? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  ssh-keygen -t ed25519 -C "mattia.racca@naverlabs.com" -f ~/.ssh/naver_ed25519
  ssh-add ~/.ssh/naver_ed25519
fi

read -p 'create SSH key for personal gmail? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  ssh-keygen -t ed25519 -C "mattia.rh@gmail.com" -f ~/.ssh/gmail_ed25519
  ssh-add ~/.ssh/gmail_ed25519
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

echo -e "\n===== Work related stuff =====\n"

read -p 'Do you want Visual Studio Code? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  wget -O /tmp/code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  sudo apt install /tmp/code.deb
fi

read -p 'Do you want miniconda? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  wget -qO- https://repo.anaconda.com/miniconda/Miniconda3-latest-$(uname)-$(uname -m).sh | less
  stow conda
fi

read -p 'Do you want Cookiecutter? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install cookiecutter
fi

read -p 'Do you want ROS2 Humble? [y/n]: ' humble
if [ "$humble" = "y" -o -z "$humble" ];then
  sudo apt install software-properties-common
  sudo add-apt-repository universe
  sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
  sudo apt update
  sudo apt install ros-humble-desktop python3-argcomplete
  sudo apt install ros-dev-tools
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

read -p 'Do you want Docker? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
	# Add Docker's official GPG key:
	sudo apt update
	sudo apt install ca-certificates
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt update
	sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker $USER
fi

read -p 'Do you want Zoom? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  wget -O /tmp/zoom.deb https://zoom.us/client/latest/zoom_amd64.deb
  sudo apt -f install /tmp/zoom.deb
  (crontab -l ; echo "@reboot nohup setsid zoom")| crontab -
fi

read -p 'Do you want Zotero? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  # firefox https://github.com/retorquere/zotero-deb
  wget -qO- https://raw.githubusercontent.com/retorquere/zotero-deb/master/install.sh | sudo bash
  # to change the icon, write simply Icon=zotero in ~/.local/share/applications/zotero.desktop
  sudo apt update
  sudo apt install zotero
fi

echo -e "===== Editing Software =====\n"

read -p 'Do you want Gimp? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo apt install gimp
fi

read -p 'Do you want Inkscape? [y/n]: ' answer
if [ "$answer" = "y" -o -z "$answer" ];then
  sudo add-apt-repository ppa:inkscape.dev/stable
  sudo apt update
  sudo apt install inkscape
fi
