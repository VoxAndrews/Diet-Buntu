#!/bin/bash

set -e

# Install IP Utilities Needed for Test
sudo apt install -y iputils-ping

clear

# Display the welcome message
echo "///////////////////////////////////////////////////////////////////////////"
echo "Welcome to the Diet-Buntu Installer - Version 22.04 (x64)"
echo "///////////////////////////////////////////////////////////////////////////"
echo ""
echo "Diet-Buntu is a streamlined version of the renowned Ubuntu operating system."
echo "Designed with efficiency in mind, it stands parallel to other lightweight"
echo "distributions like Xubuntu and Lubuntu. However, what sets Diet-Buntu apart"
echo "is its unique construction: it's built from scratch using an Ubuntu Server"
echo "Minimal Installation as its foundation."
echo ""
echo "Primarily aimed at rejuvenating lower-end machines, Diet-Buntu is versatile"
echo "enough to thrive in a variety of environments, from old laptops to modern"
echo "workstations."
echo ""
echo "As the creator of Diet-Buntu, I'm relatively new to the Linux ecosystem and"
echo "embarked on this project as a means to deepen my understanding of the OS and its"
echo "configuration intricacies. As such, Diet-Buntu remains experimental, and there"
echo "might be occasional bugs or quirks as I navigate the complexities of Linux setup"
echo "and customization. Your patience and feedback are invaluable in this learning"
echo "journey."
echo ""
echo "Diet-Buntu is not affiliated with Ubuntu and represents a fan-made modification"
echo "of a pre-existing distribution."
echo ""
echo "Ubuntu Version: 22.04 (Jammy Jellyfish)"
echo "Architecture: x86-64"
echo "Window Manager: IceWM"
echo "Version: 1.0"
echo "Script Date: 18/08/2023 (1:39am AWST)"
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
	echo "WARNING: If you enable the Themes Menu, swapping themes will change your"
	echo "wallpaper to the theme's default! However, your wallpaper will be reapplied"
	echo "on the next reboot, or, if IceWM restarts. Alternatively, you can manually"
	echo "re-apply it with Nitrogen if you wish."
	echo "///////////////////////////////////////////////////////////////////////////"
	echo ""

	# Prompt the user for their choice of whether they want to enable or disable theme menu
	while true; do
    		read -p "Do you want to enable Themes Menu? (Y/N): " yn
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

	# Display a message about the 'Entertainment Package'
	echo ""
	echo "///////////////////////////////////////////////////////////////////////////"
	echo "ENTERTAINMENT PACKAGE INSTALLATION"
	echo ""
	echo "The Entertainment Package is a set of curated games that can be installed"
	echo "onto your system. This is completly optional and will just install a"
	echo "handful of fun games for you to enjoy. The games included are:"
	echo ""
	echo "- Freeciv"
	echo "- Hedgewars"
	echo "- OpenTTD"
	echo "- Cube 2: Sauerbraten"
	echo "- Pingus"
	echo "///////////////////////////////////////////////////////////////////////////"
	echo ""

	# Prompt the user for their choice of whether they want to enable or disable theme menu
	while true; do
    		read -p "Do you want to install the Entertainment Package? (Y/N): " yn
    		case $yn in
        		[Yy]* ) 
            			entertainment_option=1; 
            			break;;
        		[Nn]* ) 
            			entertainment_option=0; 
            			break;;
        		* ) echo "Please answer Y or N.";;
    		esac
	done

	clear

	# Add Repositories
	sudo add-apt-repository -y ppa:jurplel/qview
	sudo apt-add-repository -y ppa:teejee2008/ppa

	# Initial Update and Upgrade
	sudo apt update -y && sudo apt upgrade -y

	# Install Software and Libraries from Ubuntu
	sudo apt install -y git build-essential libpam0g-dev libxcb1-dev xorg nano libgl1-mesa-dri lua5.3 vlc libgtk2.0-0 xterm polo-file-manager pulseaudio pavucontrol libreoffice libreoffice-help-en-us gvfs-backends gvfs-fuse nitrogen claws-mail qtbase5-dev libqt5x11extras5-dev libqt5svg5-dev libhunspell-dev qttools5-dev-tools qview galculator gnome-software cups printer-driver-gutenprint system-config-printer lxrandr clamav clamav-daemon libtext-csv-perl libjson-perl gnome-icon-theme cron libcommon-sense-perl libencode-perl libjson-xs-perl libtext-csv-xs-perl libtypes-serialiser-perl

	# Check the user's choice for the Entertainment Package
	if [ "$entertainment_option" == "1" ]; then
		sudo apt install -y freeciv-client-gtk freeciv-sound hedgewars openttd sauerbraten pingus
	fi

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

	wget -c https://github.com/dave-theunsub/clamtk/releases/download/v6.16/clamtk_6.16-1_all.deb
	echo "yes" | sudo dpkg -i clamtk_6.16-1_all.deb
	sudo rm clamtk_6.16-1_all.deb

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

	wget -c https://github.com/bgrabitmap/lazpaint/releases/download/v7.2.2/lazpaint7.2.2_linux64.deb
	echo "yes" | sudo dpkg -i lazpaint7.2.2_linux64.deb
	sudo rm lazpaint7.2.2_linux64.deb

	# Start/Enable Systems
	sudo systemctl enable ly.service

	# Start/Unmute Audio
	pulseaudio --start
	pacmd set-sink-volume 0 65536
	pacmd set-sink-mute 0 0

	# Install IceWM Theme
	wget -c https://github.com/vimux/icewm-theme-icepick/archive/refs/heads/master.zip
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
	wget -c https://github.com/BuddiesOfBudgie/budgie-backgrounds/releases/download/v1.0/budgie-backgrounds-v1.0.tar.xz
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

	# Apply Resolution on Reboot/IceWM Restart
	echo "" >> ~/.xsessionrc
	echo "# Extract the xrandr command from lxrandr-autostart.desktop" >> ~/.xsessionrc
	echo "xrandr_command=\$(grep \"Exec=\" ~/.config/autostart/lxrandr-autostart.desktop | cut -d\"'\" -f2)" >> ~/.xsessionrc
	echo "" >> ~/.xsessionrc
	echo "# Execute the extracted command" >> ~/.xsessionrc
	echo "eval \$xrandr_command" >> ~/.xsessionrc

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

	clear

	echo "INSTALLATION HAS COMPLETED!"
	echo ""
	echo "Press any key to reboot the system..."
	read -p ""

	# Reboot
	sudo reboot
else
    	echo "Exiting the script..."
    	exit 0
fi