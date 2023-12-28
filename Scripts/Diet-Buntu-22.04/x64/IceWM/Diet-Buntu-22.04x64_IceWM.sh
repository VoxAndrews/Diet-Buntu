#!/bin/bash

set -e

initialize_user() {
    # Determine the user who will own the files/directories
    if [ -n "$SUDO_USER" ]; then
        the_user=$SUDO_USER
    else
        the_user=$USER
    fi

    echo "Debug: Script started by $the_user" >>/home/$the_user/debug.txt
}

install_initial_packages() {
    echo "Debug: Installing IP Utilities" >>/home/$the_user/debug.txt

    sudo apt install -y dialog pciutils usbutils
}

display_welcome_message() {
    clear
    echo "Debug: Displaying welcome message" >>/home/$the_user/debug.txt

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
    echo "Version: 1.2"
    echo "Script Date: 10/10/2023 (07:07pm AWST)"
    echo ""
    echo "Would you like to continue?"
}

prompt_continue_installation() {
    choice=""

    while [[ ! "$choice" =~ ^(y|n|Y|N)$ ]]; do
        read -p "Enter Y to proceed or N to exit: " choice
    done
    choice=$(echo $choice | tr '[:upper:]' '[:lower:]')
}

check_internet_connection() {
    echo "Debug: Checking internet connection" >>/home/$the_user/debug.txt

    echo "Checking for internet connection..."

    if wget --timeout=10 -q --spider http://google.com; then
        echo "Internet connection detected."
    else
        echo "No internet connection detected. Please ensure you're connected to the internet and try again."
        exit 1
    fi
}

prompt_for_themes_menu() {
    clear
    echo "Debug: Displaying Themes Menu" >>/home/$the_user/debug.txt

    # Display a warning about theme behavior
    echo ""
    echo "///////////////////////////////////////////////////////////////////////////"
    echo "THEMES MENU"
    echo ""
    echo "This option will allow you to enable or disable the themes menu in IceWM."
    echo "Themes are ways of giving your OS a new look, and there are a few to choose"
    echo "from by default, as well as others online."
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Prompt the user for their choice of whether they want to enable or disable theme menu
    while true; do
        read -p "Do you want to enable Themes Menu? (Y/N): " yn
        case $yn in
            [Yy]*)
                theme_option=1
                break
                ;;
            [Nn]*)
                theme_option=0
                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

prompt_for_utility_software_package() {
    clear
    echo "Debug: Displaying Utility Software Package message" >>/home/$the_user/debug.txt

    # Display a message about the 'Utility Software Package'
    echo ""
    echo "///////////////////////////////////////////////////////////////////////////"
    echo "UTILITY SOFTWARE PACKAGE INSTALLATION"
    echo ""
    echo "The Utility Software Package includes essential utility software like:"
    echo "- FreeOffice: A powerful, Microsoft Office compatible suite."
    echo "- Claws Mail: An email client."
    echo "- AppGrid: A lightweight Software Center for application management."
    echo "- Drawing: A basic image editor program"
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Prompt the user for their choice of whether they install the utility software package or not
    while true; do
        read -p "Do you want to install the Utility Software Package? (Y/N): " yn
        case $yn in
            [Yy]*)
                utility_option=1
                break
                ;;
            [Nn]*)
                utility_option=0
                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

prompt_for_entertainment_package() {
    clear
    echo "Debug: Displaying Entertainment Package message" >>/home/$the_user/debug.txt

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

    # Prompt the user for their choice of whether they want to install the entertainment package or not
    while true; do
        read -p "Do you want to install the Entertainment Package? (Y/N): " yn
        case $yn in
            [Yy]*)
                entertainment_option=1
                break
                ;;
            [Nn]*)
                entertainment_option=0
                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

prompt_for_printer_package() {
    clear
    echo "Debug: Displaying Printer Package message" >>/home/$the_user/debug.txt

    # Display a message about the 'Printer Package'
    echo ""
    echo "///////////////////////////////////////////////////////////////////////////"
    echo "PRINTER PACKAGE INSTALLATION"
    echo ""
    echo "The Printer Package is a set generic drivers as well as the CUPS printing"
    echo "system, designed to give the user the compatibility with printers possible."
    echo "Included in this package is:"
    echo ""
    echo "- CUPS (Common Unix Printing System)"
    echo "- Gutenprint"
    echo "- CUPS PDF"
    echo "- HPLIP (HP Printers)"
    echo "- ESC/P-R (Epson Printers)"
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Prompt the user for their choice of whether they install the printer package or not
    while true; do
        read -p "Do you want to install the Printer Package? (Y/N): " yn
        case $yn in
            [Yy]*)
                printer_option=1
                break
                ;;
            [Nn]*)
                printer_option=0
                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

prompt_for_clamav_daemon() {
    clear
    echo "Debug: Displaying ClamAV Background Daemon message" >>/home/$the_user/debug.txt

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

    # Prompt the user for their choice of whether they want to enable or disable the ClamAV Background Daemon
    while true; do
        read -p "Do you want to disable ClamAV Background Daemon? (Y/N): " yn
        case $yn in
            [Yy]*)
                clamav_option=1
                break
                ;;
            [Nn]*)
                clamav_option=0
                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

install_packages() {
    local packages=("$@")
    sudo apt install -y "${packages[@]}"
}

download_and_install_deb() {
    local url=$1
    local deb_file="/tmp/$(basename "$url")"
    wget -c -O "$deb_file" "$url"
    sudo dpkg -i "$deb_file"
    sudo apt-get -f install
    rm "$deb_file"
}

begin_installation() {
    clear
    echo "Debug: Beginning installation process" >>/home/$the_user/debug.txt

    echo "///////////////////////////////////////////////////////////////////////////"
    echo "BEGINNING INSTALLATION..."
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Add Repositories
    sudo add-apt-repository -y ppa:jurplel/qview

    echo "Debug: Performing initial update and upgrade" >>/home/$the_user/debug.txt

    # Initial Update and Upgrade
    sudo apt update -y && sudo apt upgrade -y

    echo "Debug: Installing software and libraries from Ubuntu" >>/home/$the_user/debug.txt

    local ubuntu_packages=(git build-essential libpam0g-dev libxcb1-dev xorg nano libgl1-mesa-dri lua5.3 vlc libgtk2.0-0 xterm pcmanfm pulseaudio pavucontrol gvfs-backends gvfs-fuse qtbase5-dev libqt5x11extras5-dev libqt5svg5-dev libhunspell-dev qttools5-dev-tools qview galculator lxrandr clamav clamav-daemon libtext-csv-perl libjson-perl gnome-icon-theme cron libcommon-sense-perl libencode-perl libjson-xs-perl libtext-csv-xs-perl libtypes-serialiser-perl libcairo-gobject-perl libcairo-perl libextutils-depends-perl libglib-object-introspection-perl libglib-perl libgtk3-perl libfont-freetype-perl libxml-libxml-perl inotify-tools acpi lxappearance iputils-ping lxdm dbus connman connman-doc cmst libimlib2 libqt5printsupport5 policykit-1 lxpolkit xarchiver qpdfview)
    install_packages "${ubuntu_packages[@]}"

    # Check the user's choice for the Utility Software Package
    if [ "$utility_option" == "1" ]; then
        echo "Debug: Installing the Utility Package" >>/home/$the_user/debug.txt
        echo "Debug: Add AppGrid Repository" >>/home/$the_user/debug.txt

        # Install the AppGrid repository
        sudo add-apt-repository ppa:appgrid/stable

        echo "Debug: Create Folders/File for AppGrid" >>/home/$the_user/debug.txt
        # Create folders and files for AppGrid
        # Check if /etc/init directory exists, if not then create it
        if [ ! -d "/etc/init" ]; then
            sudo mkdir /etc/init
        fi

        # Check if /etc/init/appgrid.conf file exists, if not then create it
        if [ ! -f "/etc/init/appgrid.conf" ]; then
            sudo touch /etc/init/appgrid.conf
        fi

        # Install the Utility Software Packages
        install_packages claws-mail gnupg libgpgme11 libetpan20 libldap-2.5-0 aspell aspell-en enchant-2 libenchant-2-2 libenchant-2-voikko bogofilter claws-mail-bogofilter spamassassin claws-mail-spamassassin appgrid drawing

        # Download and Install FreeOffice
        download_and_install_deb "https://www.softmaker.net/down/softmaker-freeoffice-2021_1068-01_amd64.deb"
    fi

    # Check the user's choice for the Entertainment Package
    if [ "$entertainment_option" == "1" ]; then
        echo "Debug: Installing the Entertainment Package" >>/home/$the_user/debug.txt

        install_packages freecol openttd openttd-opensfx pingus frogatto
    fi

    if [ "$printer_option" == "1" ]; then
        echo "Debug: Installing the Printer Package" >>/home/$the_user/debug.txt
        # Install the Printer Package
        install_packages cups system-config-printer printer-driver-gutenprint hplip printer-driver-cups-pdf printer-driver-escpr

        echo "Debug: Enabling printer service (CUPS)" >>/home/$the_user/debug.txt

        # Enable Printer Service (CUPS)
        sudo systemctl start cups
        sudo systemctl enable cups
    fi

    # Check the user wants to stop the clamav daemon
    if [ "$clamav_option" == "1" ]; then
        echo "Debug: Disabling clamav daemon" >>/home/$the_user/debug.txt

        sudo systemctl stop clamav-daemon
        sudo systemctl disable clamav-daemon
    fi

    echo "Debug: Building software from source" >>/home/$the_user/debug.txt

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

    git clone https://github.com/tsujan/FeatherPad.git
    cd FeatherPad
    mkdir build && cd build
    cmake ..
    make
    sudo make install
    cd ..
    cd ..
    sudo rm -r FeatherPad

    # Start/Unmute Audio
    pulseaudio --start
    pacmd set-sink-volume 0 65536
    pacmd set-sink-mute 0 0

    # Install IceWM Theme
    wget -c https://github.com/vimux/icewm-theme-icepick/archive/refs/heads/master.zip
    unzip master.zip
    sudo mv icewm-theme-icepick-master/IcePick /usr/share/icewm/themes/
    sudo mv icewm-theme-icepick-master/preferences /usr/share/icewm/

    # Enable Task Bar Battery Monitor If Battery Is Present
    sudo sed -i '/# Taskbar/a TaskBarShowAPMAuto=1' /usr/share/icewm/preferences

    sudo rm -r icewm-theme-icepick-master master.zip
    mkdir -p /home/$the_user/.icewm
    sudo chown -R $the_user:$the_user /home/$the_user/.icewm
    echo "Theme=\"IcePick/default.theme\"" >/home/$the_user/.icewm/theme

    echo "Debug: Creating default folders" >>/home/$the_user/debug.txt

    # Create Default Folders
    mkdir -p /home/$the_user/Documents /home/$the_user/Pictures /home/$the_user/Downloads /home/$the_user/Music /home/$the_user/Videos /home/$the_user/Desktop /home/$the_user/Templates /home/$the_user/Public

    # Fix permissions (either here or right after each folder is created)
    for folder in Desktop Documents Downloads Music Pictures Videos Templates Public; do
        sudo chown $the_user:$the_user /home/$the_user/$folder
    done

    # Update the user's XDG user directories
    xdg-user-dirs-update

    echo "Debug: Downloading default wallpapers" >>/home/$the_user/debug.txt

    # Download Default Wallpapers
    wget -c https://github.com/BuddiesOfBudgie/budgie-backgrounds/releases/download/v1.0/budgie-backgrounds-v1.0.tar.xz
    tar -xf budgie-backgrounds-v1.0.tar.xz
    sudo mv budgie-backgrounds-1.0/backgrounds /home/$the_user/Pictures/
    sudo rm /home/$the_user/Pictures/backgrounds/meson.build
    rm -r budgie-backgrounds-v1.0.tar.xz budgie-backgrounds-1.0

    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND1_4K.png
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND2_4K.png
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND3_4K.png
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND4_4K.png
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND5_4K.png
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Images/Backgrounds/4K/PNG/diet-buntu_BACKGROUND6_4K.png

    sudo mv diet-buntu_BACKGROUND1_4K.png /home/$the_user/Pictures/backgrounds/
    sudo mv diet-buntu_BACKGROUND2_4K.png /home/$the_user/Pictures/backgrounds/
    sudo mv diet-buntu_BACKGROUND3_4K.png /home/$the_user/Pictures/backgrounds/
    sudo mv diet-buntu_BACKGROUND4_4K.png /home/$the_user/Pictures/backgrounds/
    sudo mv diet-buntu_BACKGROUND5_4K.png /home/$the_user/Pictures/backgrounds/
    sudo mv diet-buntu_BACKGROUND6_4K.png /home/$the_user/Pictures/backgrounds/

    # Check if the .icewm folder exists, if not create it
    if [ ! -d "/home/$the_user/.icewm" ]; then
        mkdir -p /home/$the_user/.icewm
        chown $the_user:$the_user /home/$the_user/.icewm
    else
        # If the folder already exists, just change its ownership
        chown $the_user:$the_user /home/$the_user/.icewm
    fi

    # Overwrite the preferences file in the user's .icewm folder with the one from /usr/share/icewm/
    sudo cp /usr/share/icewm/preferences /home/$the_user/.icewm/preferences
    sudo chown $the_user:$the_user /home/$the_user/.icewm/preferences

    # Download configuration file for PCManFM General Functionality
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Files/Configs/libfm.conf
    mkdir -p /home/$the_user/.config/libfm/
    sudo mv -f libfm.conf /home/$the_user/.config/libfm/libfm.conf
    chmod 664 /home/$the_user/.config/libfm/libfm.conf
    chown $the_user:$the_user /home/$the_user/.config/libfm/libfm.conf

    # Download configuration file for PCManFM Wallpaper Functionality
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Files/Configs/desktop-items-0.conf
    mkdir -p /home/$the_user/.config/pcmanfm/default/
    sudo mv -f desktop-items-0.conf /home/$the_user/.config/pcmanfm/default/desktop-items-0.conf
    chmod 664 /home/$the_user/.config/pcmanfm/default/desktop-items-0.conf
    chown $the_user:$the_user /home/$the_user/.config/pcmanfm/default/desktop-items-0.conf

    # Navigate back to the user's home directory
    cd /home/$the_user

    # Append the lines to the preferences file, using the value of $theme_option
    echo -e "\n# Diet-Buntu Changes\nShowThemesMenu=$theme_option" >>/home/$the_user/.icewm/preferences

    # Create the .config directory if it doesn't exist
    if [ ! -d "/home/$the_user/.config" ]; then
        mkdir -p "/home/$the_user/.config"
        echo "Debug: Created .config directory" >>/home/$the_user/debug.txt
    fi

    # Fix permissions for .config directory
    echo "Debug: Fixing permissions for .config directory" >>/home/$the_user/debug.txt
    sudo chown -R $the_user:$the_user /home/$the_user/.config
    sudo chmod 755 /home/$the_user/.config

    sudo usermod -aG lpadmin $the_user

    echo "Debug: Adding custom scripts" >>/home/$the_user/debug.txt

    # Create the .scripts folder if it doesn't exist
    if [ ! -d "/home/$the_user/.scripts" ]; then
        mkdir "/home/$the_user/.scripts"
    fi

    # Download the desktop_icon_scan.sh script
    wget -c -P "/home/$the_user/.scripts/" "https://github.com/VoxAndrews/Diet-Buntu/raw/main/Scripts/Utilities/PCManFM/desktop_icon_scan.sh"

    # Set permissions
    chmod +x "/home/$the_user/.scripts/desktop_icon_scan.sh"
    chown $the_user:$the_user "/home/$the_user/.scripts"
    chown $the_user:$the_user "/home/$the_user/.scripts/desktop_icon_scan.sh"

    # Add Programs/Scripts to Startup
    # .xinitrc Process
    # Apply Resolution on Reboot/IceWM Restart
    echo "" >>/home/$the_user/.xinitrc
    echo "# Extract the xrandr command from lxrandr-autostart.desktop" >>/home/$the_user/.xinitrc
    echo "xrandr_command=\$(grep \"Exec=\" /home/$the_user/.config/autostart/lxrandr-autostart.desktop | cut -d\"'\" -f2)" >>/home/$the_user/.xinitrc
    echo "" >>/home/$the_user/.xinitrc
    echo "# Execute the extracted command" >>/home/$the_user/.xinitrc
    echo "eval \$xrandr_command" >>/home/$the_user/.xinitrc

    # .xsessionrc Process
    # Add pcmanfm to startup
    echo "pcmanfm --desktop &" >>/home/$the_user/.xsessionrc

    # Add Daemon's to Startup
    echo "xscreensaver -nosplash &" >>/home/$the_user/.xsessionrc

    # Startup Programs/Scripts
    echo "/home/$the_user/.scripts/desktop_icon_scan.sh &" >>/home/$the_user/.xsessionrc
    echo "/usr/bin/lxpolkit &" >>/home/$the_user/.xsessionrc
    echo "cmst --minimized &" >>/home/$the_user/.xsessionrc

    chown $the_user:$the_user /home/$the_user/.xinitrc
    chown $the_user:$the_user /home/$the_user/.xsessionrc

    echo "Debug: Setting Up Theming For Desktop" >>/home/$the_user/debug.txt

    # Install the Papirus icon theme
    cd ~
    git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git
    cd papirus-icon-theme
    sudo ./install.sh

    # Go back to the home directory and remove the cloned folder
    cd ~
    rm -rf papirus-icon-theme

    # File to be edited or created
    file=/home/$the_user/.gtkrc-2.0

    # Check if the file exists
    if [ -f "$file" ]; then
        # Check for existing lines and edit them, or append if they don't exist
        grep -q "gtk-icon-theme-name=" $file && sudo sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name="Papirus-Dark"/' $file || echo 'gtk-icon-theme-name="Papirus-Dark"' >>$file
        grep -q "gtk-theme-name=" $file && sudo sed -i 's/gtk-theme-name=.*/gtk-theme-name="Industrial"/' $file || echo 'gtk-theme-name="Industrial"' >>$file
    else
        # Create the file and add the lines
        touch $file
        echo "# Custom GTK 2.0 settings" >>$file
        echo 'gtk-icon-theme-name="Papirus-Dark"' >>$file
        echo 'gtk-theme-name="Industrial"' >>$file
    fi

    echo "Debug: Updating and upgrading software" >>/home/$the_user/debug.txt

    # Update and Upgrade Software
    sudo apt update && sudo apt upgrade

    echo "Debug: Cleaning and removing orphaned files/data" >>/home/$the_user/debug.txt

    # Remove Unnecessary Packages
    sudo apt remove lximage-qt qt5-assistant build-essential libpam0g-dev libxcb1-dev qtbase5-dev libqt5x11extras5-dev libqt5svg5-dev libhunspell-dev qttools5-dev-tools vim vim-common vim-tiny htop byobu

    # Clean and Remove Orphaned Files/Data
    sudo apt autoremove -y
    sudo apt autoclean -y

    # Update Bootloader
    sudo update-grub

    sudo chown $the_user:$the_user /home/$the_user/debug.txt
}

exit_message() {
    clear
    echo "Debug: Determining the user for the install" >>/home/$the_user/debug.txt

    echo "Debug: Displaying installation completion message" >>/home/$the_user/debug.txt

    echo "///////////////////////////////////////////////////////////////////////////"
    echo "INSTALLATION HAS COMPLETED!"
    echo ""
    echo "Thankyou for installing Diet-Buntu! For any feedback or bug reports, please"
    echo "go online to the script's repository at:"
    echo ""
    echo "https://github.com/VoxAndrews/Diet-Buntu/"
    echo ""
    echo "Debug logs are avalible at /home/$the_user/debug.txt"
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""
    echo "Press Enter to reboot the system..."
    read -p ""

    echo "Debug: Rebooting" >>/home/$the_user/debug.txt

    # Reboot
    sudo reboot
}

main() {
    initialize_user
    check_internet_connection
    install_initial_packages
    display_welcome_message
    prompt_continue_installation

    if [ "$choice" == "y" ]; then
        prompt_for_themes_menu
        prompt_for_utility_software_package
        prompt_for_entertainment_package
        prompt_for_printer_package
        prompt_for_clamav_daemon
        begin_installation
        exit_message
    else
        echo "Exiting the script..."
        exit 0
    fi
}

main
EOF
