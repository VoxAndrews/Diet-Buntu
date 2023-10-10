#!/bin/bash

set -e

# Determine the user who will own the files/directories
if [ -n "$SUDO_USER" ]; then
   	the_user=$SUDO_USER
else
    	the_user=$USER
fi

echo "Debug: Installing IP Utilities" >> /home/$the_user/debug.txt

# Install IP Utilities Needed for Test
sudo apt install -y iputils-ping dialog

clear

echo "Debug: Displaying welcome message" >> /home/$the_user/debug.txt

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
echo "Version: 1.1"
echo "Script Date: 10/10/2023 (04:29pm AWST)"
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

echo "Debug: Checking internet connection" >> /home/$the_user/debug.txt

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

	echo "Debug: Displaying Themes Menu" >> /home/$the_user/debug.txt

	# Display a warning about theme behavior
	echo ""
	echo "///////////////////////////////////////////////////////////////////////////"
	echo "THEMES MENU"
	echo ""
	echo "This option will allow you to enable or disable the themes menu in IceWM."
	echo "Themes are ways of giving your OS a new look, and there are a few to choose"
	echo "from by default, as well as others online."
	echo ""
	echo "WARNING: If you enable the Themes Menu, swapping themes may change your"
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

	echo "Debug: Displaying Utility Software Package message" >> /home/$the_user/debug.txt

	# Display a message about the 'Utility Software Package'
	echo ""
	echo "///////////////////////////////////////////////////////////////////////////"
	echo "UTILITY SOFTWARE PACKAGE INSTALLATION"
	echo ""
	echo "The Utility Software Package includes essential utility software like:"
	echo "- FreeOffice: A powerful, Microsoft Office compatible suite."
	echo "- Claws Mail: An email client."
	echo "- GNOME Software: Software Center for application management."
	echo "- Drawing: A basic image editor program"
	echo "///////////////////////////////////////////////////////////////////////////"
	echo ""

	# Prompt the user for their choice
	while true; do
    		read -p "Do you want to install the Utility Software Package? (Y/N): " yn
    		case $yn in
        		[Yy]* ) 
            			utility_option=1; 
            			break;;
        		[Nn]* ) 
            			utility_option=0; 
            			break;;
        		* ) echo "Please answer Y or N.";;
    		esac
	done

	clear

	echo "Debug: Displaying Entertainment Package message" >> /home/$the_user/debug.txt

	# Display a message about the 'Entertainment Package'
	echo ""
	echo "///////////////////////////////////////////////////////////////////////////"
	echo "ENTERTAINMENT PACKAGE INSTALLATION"
	echo ""
	echo "The Entertainment Package is a set of curated games that can be installed"
	echo "onto your system. This is completly optional and will just install a"
	echo "handful of fun games for you to enjoy. The games included are:"
	echo ""
	echo "- FreeCol"
	echo "- OpenTTD"
	echo "- Pingus"
	echo "- Frogatto"
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

	echo "Debug: Displaying ClamAV Background Daemon message" >> /home/$the_user/debug.txt

	# Display a message about enabling or disabling ClamAV Background Daemon
	echo ""
	echo "///////////////////////////////////////////////////////////////////////////"
	echo "CLAMAV BACKGROUND DAEMON"
	echo ""
	echo "ClamAV is the Anti-Virus used on your system, and provides you with a way"
	echo "to stay safe while using it. It has a Daemon (Program which runs in the"
	echo "background) which automatically updates your virus database and keeps your"
	echo "system in check. However, this Daemon consumes a lot of resources, which"
	echo "can make it harder to run multiple pieces of software on older systems. You"
	echo "can decide to disable this background process if you like and use Clamtk"
	echo "to manually scan your system and keep your databases up to date, and your"
	echo "resource usage will remain low (E.g. ~1500MB RAM usage with Daemon, ~300MB" 
	echo "RAM usage without)."
	echo ""
	echo "NOTE: If you wish to re-enable it after this, at any time you can open the"
	echo "Terminal and run these commands:"
	echo ""
	echo "sudo systemctl start clamav-daemon"
	echo "sudo systemctl enable clamav-daemon"
	echo "///////////////////////////////////////////////////////////////////////////"
	echo ""

	# Prompt the user for their choice of whether they want to enable or disable theme menu
	while true; do
    		read -p "Do you want to disable ClamAV Background Daemon? (Y/N): " yn
    		case $yn in
        		[Yy]* ) 
            			clamav_option=1; 
            			break;;
        		[Nn]* ) 
            			clamav_option=0; 
            			break;;
        		* ) echo "Please answer Y or N.";;
    		esac
	done

	clear

	echo ""
	echo "///////////////////////////////////////////////////////////////////////////"
	echo "BEGINNING INSTALLATION..."
	echo "///////////////////////////////////////////////////////////////////////////"
	echo ""

	echo "Debug: Adding repositories" >> /home/$the_user/debug.txt

	# Add Repositories
	sudo add-apt-repository -y ppa:jurplel/qview
	sudo apt-add-repository -y ppa:teejee2008/ppa

	echo "Debug: Performing initial update and upgrade" >> /home/$the_user/debug.txt

	# Initial Update and Upgrade
	sudo apt update -y && sudo apt upgrade -y

	echo "Debug: Installing software and libraries from Ubuntu" >> /home/$the_user/debug.txt

	# Install Software and Libraries from Ubuntu
	sudo apt install -y git build-essential libpam0g-dev libxcb1-dev xorg nano libgl1-mesa-dri lua5.3 vlc libgtk2.0-0 xterm polo-file-manager pulseaudio pavucontrol gvfs-backends gvfs-fuse nitrogen qtbase5-dev libqt5x11extras5-dev libqt5svg5-dev libhunspell-dev qttools5-dev-tools qview galculator cups printer-driver-gutenprint system-config-printer lxrandr clamav clamav-daemon libtext-csv-perl libjson-perl gnome-icon-theme cron libcommon-sense-perl libencode-perl libjson-xs-perl libtext-csv-xs-perl libtypes-serialiser-perl libcairo-gobject-perl libcairo-perl libextutils-depends-perl libglib-object-introspection-perl libglib-perl libgtk3-perl libfont-freetype-perl libxml-libxml-perl

	# Check the user's choice for the Utility Software Package
	if [ "$utility_option" == "1" ]; then
    		sudo apt install -y claws-mail gnome-software drawing

		wget -c https://www.softmaker.net/down/softmaker-freeoffice-2021_1064-01_amd64.deb
		sudo dpkg -i softmaker-freeoffice-2021_1064-01_amd64.deb
    		sudo rm softmaker-freeoffice-2021_1064-01_amd64.deb
	fi

	# Check the user's choice for the Entertainment Package
	if [ "$entertainment_option" == "1" ]; then
		sudo apt install -y freecol openttd openttd-opensfx pingus frogatto
	fi

	# Check the user wants to stop the clamav daemon
	if [ "$clamav_option" == "1" ]; then
        	sudo systemctl stop clamav-daemon
		sudo systemctl disable clamav-daemon
    	fi

	echo "Debug: Downloading and installing/building software" >> /home/$the_user/debug.txt

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
	mkdir -p /home/$the_user/.icewm
	sudo chown -R $the_user:$the_user /home/$the_user/.icewm
	echo "Theme=\"IcePick/default.theme\"" > /home/$the_user/.icewm/theme

	echo "Debug: Creating default folders" >> /home/$the_user/debug.txt

	# Create Default Folders
	mkdir -p /home/$the_user/Documents /home/$the_user/Pictures /home/$the_user/Downloads /home/$the_user/Music /home/$the_user/Videos /home/$the_user/Desktop

	# Fix permissions (either here or right after each folder is created)
	for folder in Desktop Documents Downloads Music Pictures Videos; do
  		sudo chown $the_user:$the_user /home/$the_user/$folder
	done

	echo "Debug: Downloading default wallpapers" >> /home/$the_user/debug.txt

	# Download Default Wallpapers
	wget -c https://github.com/BuddiesOfBudgie/budgie-backgrounds/releases/download/v1.0/budgie-backgrounds-v1.0.tar.xz
	tar -xf budgie-backgrounds-v1.0.tar.xz
	sudo mv budgie-backgrounds-1.0/backgrounds /usr/share/
	sudo rm /usr/share/backgrounds/meson.build
	rm -r budgie-backgrounds-v1.0.tar.xz budgie-backgrounds-1.0

	wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND1_4K.png
	wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND2_4K.png
	wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND3_4K.png

	sudo mv diet-buntu_BACKGROUND1_4K.png /usr/share/backgrounds/
	sudo mv diet-buntu_BACKGROUND2_4K.png /usr/share/backgrounds/
	sudo mv diet-buntu_BACKGROUND3_4K.png /usr/share/backgrounds/

	# Fix permissions for .config directory
	echo "Debug: Fixing permissions for .config directory" >> /home/$the_user/debug.txt
	sudo chown -R $the_user:$the_user /home/$the_user/.config
	chmod 755 /home/$the_user/.config

	## Set Background To Default
	# Create Nitrogen Config Directory
	mkdir -p /home/$the_user/.config/nitrogen/

	# Define variables
	CONFIG_DIR="/home/$the_user/.config/nitrogen/"
	CONFIG_FILE="${CONFIG_DIR}bg-saved.cfg"
	NITROGEN_FILE="${CONFIG_DIR}nitrogen.cfg"

	# Create Nitrogen Config Directory
	mkdir -p $CONFIG_DIR

	# Set Background Folder Location
	echo "[xin_-1]" > $CONFIG_FILE
	echo "file=/usr/share/backgrounds/diet-buntu_BACKGROUND1_4K.png" >> $CONFIG_FILE
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

	# Apply Wallpaper On Reboot
	echo "nitrogen --restore &" >> /home/$the_user/.xsessionrc
	chown $the_user:$the_user /home/$the_user/.xsessionrc

	# Check if the .icewm folder exists, if not create it
	if [ ! -d "/home/$the_user/.icewm" ]; then
    		mkdir -p /home/$the_user/.icewm
    		chown $the_user:$the_user /home/$the_user/.icewm
	else
    		# If the folder already exists, just change its ownership
    		chown $the_user:$the_user /home/$the_user/.icewm
	fi

	# Overwrite the preferences file in the user's .icewm folder with the one from /usr/share/icewm/
	cp /usr/share/icewm/preferences /home/$the_user/.icewm/preferences
	chown $the_user:$the_user /home/$the_user/.icewm/preferences

	# Apply Wallpaper When Restarting IceWM
	touch /home/$the_user/.icewm/startup
	chmod +x /home/$the_user/.icewm/startup
	echo "icesh guievents | awk '/startup|restart/ { system(\"nitrogen --restore &\") }'" > /home/$the_user/.icewm/startup

	# Navigate back to the user's home directory
	cd /home/$the_user

	# Append the lines to the preferences file, using the value of $theme_option
	echo -e "\n# Diet-Buntu Changes\nShowThemesMenu=$theme_option" >> /home/$the_user/.icewm/preferences

	# Apply Resolution on Reboot/IceWM Restart
	echo "" >> /home/$the_user/.xsessionrc
	echo "# Extract the xrandr command from lxrandr-autostart.desktop" >> /home/$the_user/.xsessionrc
	echo "xrandr_command=\$(grep \"Exec=\" /home/$the_user/.config/autostart/lxrandr-autostart.desktop | cut -d\"'\" -f2)" >> /home/$the_user/.xsessionrc
	echo "" >> /home/$the_user/.xsessionrc
	echo "# Execute the extracted command" >> /home/$the_user/.xsessionrc
	echo "eval \$xrandr_command" >> /home/$the_user/.xsessionrc

	echo "Debug: Enabling printer service (CUPS)" >> /home/$the_user/debug.txt

	# Enable Printer Service (CUPS)
	sudo systemctl start cups
	sudo systemctl enable cups

	sudo usermod -aG lpadmin $the_user

	# Add Daemon's to Startup
	echo "xscreensaver -nosplash &" >> /home/$the_user/.xsessionrc

	echo "Debug: Updating and upgrading software" >> /home/$the_user/debug.txt

	# Update and Upgrade Software
	sudo apt update && sudo apt upgrade

	echo "Debug: Cleaning and removing orphaned files/data" >> /home/$the_user/debug.txt

	# Remove Unnecessary Packages
	sudo apt remove lximage-qt qt5-assistant

	# Clean and Remove Orphaned Files/Data
	sudo apt autoremove -y
	sudo apt autoclean -y

	# Update Bootloader
	sudo update-grub

	sudo chown $the_user:$the_user /home/$the_user/debug.txt

	clear

	echo "Debug: Displaying installation completion message" >> /home/$the_user/debug.txt

	echo "///////////////////////////////////////////////////////////////////////////"
	echo "INSTALLATION HAS COMPLETED!"
	echo ""
	echo "Thankyou for installing Diet-Buntu! For any feedback or bug reports, please"
	echo "go online to the script's repository at:"
	echo ""
	echo "https://github.com/VoxAndrews/Diet-Buntu/"
	echo "///////////////////////////////////////////////////////////////////////////"
	echo ""
	echo "Press Enter to reboot the system..."
	read -p ""

	echo "Debug: Rebooting" >> /home/$the_user/debug.txt

	# Reboot
	sudo reboot
else
    	echo "Exiting the script..."
    	exit 0
fi