#!/bin/bash

set -e

# Display the welcome message
echo "///////////////////////////////////////////////////////////////////////////"
echo "Welcome to the Diet-Buntu Installer - Version 22.04 (x64)"
echo "///////////////////////////////////////////////////////////////////////////"
echo ""
echo "Diet-Buntu is a streamlined version of the renowned Ubuntu operating system. Designed with efficiency in mind, it stands parallel to other lightweight distributions like Xubuntu and Lubuntu. However, what sets Diet-Buntu apart is its unique construction: it's built from scratch using an Ubuntu Server Minimal Installation as its foundation. From this minimalistic starting point, essential components are meticulously added, either sourced from Ubuntu's official packages or built directly from source code."
echo ""
echo "Primarily aimed at rejuvenating lower-end machines, Diet-Buntu is versatile enough to thrive in a variety of environments, from old laptops to modern workstations. The result is a lean, yet fully functional OS tailored for users seeking performance without excess."
echo ""
echo "As the creator of Diet-Buntu, I'm relatively new to the Linux ecosystem and embarked on this project as a means to deepen my understanding of the OS and its configuration intricacies. As such, Diet-Buntu remains experimental, and there might be occasional bugs or quirks as I navigate the complexities of Linux setup and customization. Your patience and feedback are invaluable in this learning journey."
echo ""
echo "Diet-Buntu is not affiliated with Ubuntu and represents a fan-made modification of a pre-existing distribution."
echo ""
echo "Ubuntu Version: 22.04 (Jammy Jellyfish)"
echo "Architecture: x86-64"
echo "Version: 1.0"
echo "Script Date: 17/08/2023 (11:36pm AWST)"
echo ""
echo "Would you like to continue?"

# Initialize choice as an empty string
choice=""

# Keep prompting the user until they enter Y or N
while [[ ! "$choice" =~ ^(y|n|Y|N)$ ]]; do
    read -p "Enter Y to proceed or N to exit: " choice
done

# Convert the choice to lowercase to handle both upper and lower case inputs
choice=$(echo $choice | tr '[:upper:]' '[:lower:]')

# Check the user's choice
if [ "$choice" == "y" ]; then
	echo "Proceeding with the script..."

	clear
    
	check_internet() {
    		echo "Checking for internet connection..."
    		ping -c 1 8.8.8.8 > /dev/null 2>&1
    		if [ $? -ne 0 ]; then
        		echo "No internet connection detected. Please ensure you're connected to the internet and try again."
        		exit 1
    		else
        		echo "Internet connection detected. Continuing with installer..."
    		fi
	}

	# Call the function
	check_internet

	clear

	# Display a warning about theme behavior
	echo ""
	echo "///////////////////////////////////////////////////////////////////////////"
	echo "WARNING: If you enable themes, swapping themes will change your wallpaper."
	echo "Your wallpaper will be reapplied on the next reboot."
	echo "Alternatively, you can manually apply it with Nitrogen."
	echo "///////////////////////////////////////////////////////////////////////////"
	echo ""

	# Prompt the user for their choice of whether they want to enable or disable theme menu
	while true; do
    		read -p "Do you want to enable Theme Options? (Y/N): " yn
    		case $yn in
        		[Yy]* ) 
            			theme_option=1; 
            			break;;
        		[Nn]* ) 
            			theme_option=0; 
            			break;;
        		* ) echo "Please answer Y or N.";;
    		esac
	done

	clear

	# Add Repositories
	sudo add-apt-repository ppa:jurplel/qview
	sudo apt-add-repository ppa:teejee2008/ppa

	# Initial Update and Upgrade
	sudo apt update -y && sudo apt upgrade -y

	# Install Software and Libraries from Ubuntu
	sudo apt install -y git build-essential libpam0g-dev libxcb1-dev xorg nano libgl1-mesa-dri lua5.3 vlc libgtk2.0-0 xterm polo-file-manager pulseaudio pavucontrol libreoffice libreoffice-help-en-us gvfs-backends gvfs-fuse nitrogen claws-mail qtbase5-dev libqt5x11extras5-dev libqt5svg5-dev libhunspell-dev qttools5-dev-tools qview galculator gnome-software cups printer-driver-gutenprint system-config-printer

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
	echo "yes" | sudo dpkg -i peazip_9.3.0.LINUX.GTK2-1_amd64.deb
	sudo rm peazip_9.3.0.LINUX.GTK2-1_amd64.deb

	echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:stevenpusser.list
	curl -fsSL https://download.opensuse.org/repositories/home:stevenpusser/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee 	/etc/apt/trusted.gpg.d/home_stevenpusser.gpg > /dev/null
	sudo apt update
	sudo apt install -y palemoon

	git clone https://github.com/tsujan/FeatherPad.git
	cd FeatherPad
	mkdir build && cd build
	cmake ..
	make
	sudo make install
	cd ..
	cd ..
	sudo rm -r FeatherPad

	wget https://github.com/bgrabitmap/lazpaint/releases/download/v7.2.2/lazpaint7.2.2_linux64.deb
	echo "yes" | sudo dpkg -i lazpaint7.2.2_linux64.deb
	sudo rm lazpaint7.2.2_linux64.deb

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
	sudo mv budgie-backgrounds-1.0/backgrounds /usr/share/
	sudo rm /usr/share/backgrounds/meson.build
	rm -r budgie-backgrounds-v1.0.tar.xz budgie-backgrounds-1.0

	## Set Background To Default
	# Create Nitrogen Config Directory
	mkdir -p $HOME/.config/nitrogen/

	# Define variables
	CONFIG_FILE="$HOME/.config/nitrogen/bg-saved.cfg"
	NITROGEN_FILE="$HOME/.config/nitrogen/nitrogen.cfg"

	# Set Background Folder Location
	echo "[xin_-1]" > $CONFIG_FILE
	echo "file=/usr/share/backgrounds/waves-midnight.jpg" >> $CONFIG_FILE
	echo "mode=5" >> $CONFIG_FILE
	echo "bgcolor=#000000" >> $CONFIG_FILE

	# Overwrite the Current Background
	echo "[geometry]" > $NITROGEN_FILE
	echo "posx=502" >> $NITROGEN_FILE
	echo "posy=31" >> $NITROGEN_FILE
	echo "sizex=510" >> $NITROGEN_FILE
	echo "sizex=500" >> $NITROGEN_FILE
	echo "" >> $NITROGEN_FILE
	echo "[nitrogen]" >> $NITROGEN_FILE
	echo "view=icon" >> $NITROGEN_FILE
	echo "recurse=true" >> $NITROGEN_FILE
	echo "sort=alpha" >> $NITROGEN_FILE
	echo "icon_caps=false" >> $NITROGEN_FILE
	echo "dirs=/usr/share/backgrounds;" >> $NITROGEN_FILE

	# Apply Wallpaper On Reboot/IceWM Restart
	echo "nitrogen --restore &" >> ~/.xsessionrc

	# After installing IceWM and the IcePick theme, apply the option to the user's account
	echo "ShowThemesMenu=$theme_option" > ~/.icewm/prefoverride

	# Enable Printer Service (CUPS)
	sudo systemctl start cups
	sudo systemctl enable cups

	sudo usermod -aG lpadmin $USER

	# Add Daemon's to Startup
	echo "xscreensaver -nosplash &" >> ~/.xsessionrc

	# Update and Upgrade Software
	sudo apt update && sudo apt upgrade

	# Remove Unnecessary Packages
	sudo apt remove lximage-qt qt5-assistant

	# Clean and Remove Orphaned Files/Data
	sudo apt autoremove -y
	sudo apt autoclean -y

	# Update Bootloader
	sudo update-grub

	# Reboot
	sudo reboot
else
    	echo "Exiting the script..."
    	exit 0
fi