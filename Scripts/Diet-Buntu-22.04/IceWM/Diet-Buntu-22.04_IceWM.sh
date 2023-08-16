#!/bin/bash

set -e

check_internet() {
    echo "Checking for internet connection..."
    ping -c 1 8.8.8.8 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "No internet connection detected. Please ensure you're connected to the internet and try again."
        exit 1
    else
        echo "Internet connection detected."
    fi
}

# Call the function
check_internet

# Initial Update and Upgrade
sudo apt update -y && sudo apt upgrade -y

# Install Latest 5.15 Kernels
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.126/amd64/linux-headers-5.15.126-0515126-generic_5.15.126-0515126.202308111531_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.126/amd64/linux-headers-5.15.126-0515126_5.15.126-0515126.202308111531_all.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.126/amd64/linux-image-unsigned-5.15.126-0515126-generic_5.15.126-0515126.202308111531_amd64.deb
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.126/amd64/linux-modules-5.15.126-0515126-generic_5.15.126-0515126.202308111531_amd64.deb
dpkg --list | grep linux-image | awk '{ print $2 }' | grep -v `uname -r` | grep -v '5.15.126' | xargs sudo apt-get -y purge
sudo apt autoremove
sudo apt autoclean
sudo update-grub
sudo dpkg -i *.deb
sudo rm *.deb

# Install Software and Libraries from Ubuntu
sudo apt install build-essential libpam0g-dev libxcb1-dev xorg nano libgl1-mesa-dri lua5.3 vlc libgtk2.0-0 xterm thunar pulseaudio pavucontrol libreoffice libreoffice-help-en-us gvfs-backends gvfs-fuse nitrogen pineapple-pictures claws-mail

# Download and Install/Build Software
git clone --recurse-submodules https://github.com/fairyglade/ly
cd ly
make
sudo make install installsystemd
cd ..
sudo rm -r ly

# Download and Install/Build Software
git clone https://github.com/bbidulock/icewm.git
wget -c https://ice-wm.org/scripts/os-depends.sh
sudo bash -x ./os-depends.sh
cd icewm
sudo ./autogen.sh
sudo ./configure
sudo make
sudo make DESTDIR="$pkgdir" install
cd ..
sudo rm -r icewm
sudo rm -r os-depends.sh

wget -c https://github.com/peazip/PeaZip/releases/download/9.3.0/peazip_9.3.0.LINUX.GTK2-1_amd64.deb
sudo dpkg -i peazip_9.3.0.LINUX.GTK2-1_amd64.deb
sudo rm peazip_9.3.0.LINUX.GTK2-1_amd64.deb

echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:stevenpusser.list
curl -fsSL https://download.opensuse.org/repositories/home:stevenpusser/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_stevenpusser.gpg > /dev/null
sudo apt update
sudo apt install palemoon

# Start/Enable Systems
sudo systemctl enable ly.service

# Start/Unmute Audio
pulseaudio --start
pacmd set-sink-volume 0 65536
pacmd set-sink-mute 0 0

# Install IceWM Theme
wget https://github.com/vimux/icewm-theme-icepick/archive/refs/heads/master.zip
unzip master.zip
sudo mv icewm-theme-icepick-master/IcePick /usr/share/icewm/themes/
sudo mv icewm-theme-icepick-master/preferences /usr/share/icewm/
sudo rm -r icewm-theme-icepick-master master.zip
mkdir -p ~/.icewm
sudo chown -R $USER:$USER ~/.icewm
echo "Theme=\"IcePick/default.theme\"" > ~/.icewm/theme

# Create Default Files
mkdir -p ~/Documents ~/Pictures ~/Downloads ~/Music ~/Videos ~/Desktop

# Download Default Wallpapers
wget https://github.com/BuddiesOfBudgie/budgie-backgrounds/releases/download/v1.0/budgie-backgrounds-v1.0.tar.xz
tar -xf budgie-backgrounds-v1.0.tar.xz
mv budgie-backgrounds-1.0/backgrounds ~/Pictures/
rm ~/Pictures/backgrounds/meson.build
rm -r budgie-backgrounds-v1.0.tar.xz budgie-backgrounds-1.0

# Set Background To Set
echo "nitrogen --restore &" > ~/.icewm/startup
chmod +x ~/.icewm/startup

# Setup Thunar
xfconf-query -c thunar-volman -p /automount-drives/enabled -s true
xfconf-query -c thunar-volman -p /automount-media/enabled -s true
xfconf-query -c thunar-volman -p /autobrowse/enabled -s true

echo -e "[Desktop Entry]\nVersion=1.0\nName=XTerm\nComment=Use the command line\nExec=xterm\nTerminal=false\nType=Application\nIcon=xterm\nCategories=System;TerminalEmulator;" | sudo tee /usr/share/applications/xfce4-terminal.desktop > /dev/null

# Update and Upgrade Software
sudo apt update && sudo apt upgrade

# Reboot
sudo reboot