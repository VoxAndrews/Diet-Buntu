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
    echo "Welcome to the Diet-Buntu Installer!"
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""
    echo "Diet-Buntu is a streamlined version of the Ubuntu operating system."
    echo ""
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
    echo "Script Date: 23/02/2023 (12:20am AWST)"
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

        echo "Debug: Internet connection detected" >>/home/$the_user/debug.txt
    else
        echo "No internet connection detected. Please ensure you're connected to the internet and try again."

        echo "Debug: No internet connection detected" >>/home/$the_user/debug.txt

        exit 1
    fi
}

select_timezone() {
    clear
    echo "Debug: Displaying timezone selection dialog" >>/home/$the_user/debug.txt

    tempfile=$(mktemp) # Create a temporary file to store the list of timezones
    tempout=$(mktemp)  # Create a temporary file to capture the user's selection

    timedatectl list-timezones >$tempfile # Save the list to the temporary file

    confirmed=0 # Set the confirmed flag to 0 (false) to start the loop

    echo "Debug: Prompting user to select timezone" >>/home/$the_user/debug.txt

    while [ $confirmed -eq 0 ]; do
        # Use dialog to present the list to the user and capture the selection
        dialog --title "Select your timezone" --menu "Choose one" 25 80 17 $(awk '{print NR " " $0}' $tempfile) 2>$tempout
        response=$? # Get the exit status

        if [ $response -eq 1 ]; then
            # User pressed Cancel or closed the dialog window
            clear

            echo "Debug: Timezone selection cancelled" >>/home/$the_user/debug.txt

            echo "Timezone selection cancelled."

            rm $tempfile $tempout # Clean up

            exit 1
        fi

        selected_timezone=$(<"$tempout")                    # Read the user's selection from the file
        timezone=$(sed "${selected_timezone}q;d" $tempfile) # Get the timezone from the list

        # Ask for confirmation
        dialog --title "Confirmation" --yesno "Are you sure you want to set the timezone to $timezone?" 7 60
        if [ $? -eq 0 ]; then
            # User confirmed
            echo "Debug: Timezone confirmed: $timezone" >>/home/$the_user/debug.txt

            sudo timedatectl set-ntp true # Enable NTP to ensure the system clock is accurate

            sudo timedatectl set-timezone "$timezone" # Set the timezone

            echo "Timezone updated to $timezone."

            confirmed=1
        fi
    done

    rm $tempfile $tempout # Clean up
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
    echo ""
    echo "Websites like box-look.org and gnome-look.org have a variety of themes to"
    echo "choose from, and you can download and install them to your system. However,"
    echo "keep in mind that some themes may not work as expected, and some may even"
    echo "cause issues with your system. It's recommended to only download themes from"
    echo "trusted sources and to always have a backup theme in case something goes"
    echo "wrong."
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Prompt the user for their choice of whether they want to enable or disable theme menu
    while true; do
        read -p "Do you want to enable Themes Menu? (Y/N): " yn
        case $yn in
            [Yy]*)
                theme_option=1

                echo "Debug: User chose to enable Themes Menu" >>/home/$the_user/debug.txt

                break
                ;;
            [Nn]*)
                theme_option=0

                echo "Debug: User chose to disable Themes Menu" >>/home/$the_user/debug.txt

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

                echo "Debug: User chose to install the Utility Software Package" >>/home/$the_user/debug.txt

                break
                ;;
            [Nn]*)
                utility_option=0

                echo "Debug: User chose not to install the Utility Software Package" >>/home/$the_user/debug.txt

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

    # Prompt the user for their choice of whether they want to enable or disable theme menu
    while true; do
        read -p "Do you want to install the Entertainment Package? (Y/N): " yn
        case $yn in
            [Yy]*)
                entertainment_option=1

                echo "Debug: User chose to install the Entertainment Package" >>/home/$the_user/debug.txt

                break
                ;;
            [Nn]*)
                entertainment_option=0

                echo "Debug: User chose not to install the Entertainment Package" >>/home/$the_user/debug.txt

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

                echo "Debug: User chose to install the Printer Package" >>/home/$the_user/debug.txt

                break
                ;;
            [Nn]*)
                printer_option=0

                echo "Debug: User chose not to install the Printer Package" >>/home/$the_user/debug.txt

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

                echo "Debug: User chose to disable ClamAV Background Daemon" >>/home/$the_user/debug.txt

                break
                ;;
            [Nn]*)
                clamav_option=0

                echo "Debug: User chose not to disable ClamAV Background Daemon" >>/home/$the_user/debug.txt

                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

prompt_for_connman_service() {
    clear
    echo "Debug: Displaying ConnMan Service message" >>/home/$the_user/debug.txt

    # Display a message about enabling or disabling ConnMan Wait for Network Service
    echo ""
    echo "///////////////////////////////////////////////////////////////////////////"
    echo "CONNMAN WAIT FOR NETWORK SERVICE"
    echo ""
    echo "Your system uses ConnMan to manage network connections. During startup, a"
    echo "service waits for ConnMan to configure the network before continuing. This"
    echo "can cause delays, especially if there's no immediate network connection (e.g.,"
    echo "if you need to manually connect to Wi-Fi)."
    echo ""
    echo "Disabling this service will allow your system to boot without waiting for a"
    echo "network connection, but it might affect other network-dependent services."
    echo ""
    echo "You can always re-enable this service by running:"
    echo ""
    echo "sudo systemctl enable connman-wait-online.service"
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Prompt the user for their choice to enable or disable the ConnMan service
    while true; do
        read -p "Do you want to disable ConnMan Wait for Network Service? (Y/N): " yn
        case $yn in
            [Yy]*)
                connman_service_option=1

                echo "Debug: User chose to disable ConnMan Wait for Network Service" >>/home/$the_user/debug.txt

                break
                ;;
            [Nn]*)
                connman_service_option=0

                echo "Debug: User chose not to disable ConnMan Wait for Network Service" >>/home/$the_user/debug.txt

                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

prompt_for_picom_compositor() {
    clear
    echo "Debug: Displaying Picom message" >>/home/$the_user/debug.txt

    # Display a message about enabling or disabling Picom
    echo ""
    echo "///////////////////////////////////////////////////////////////////////////"
    echo "PICOM - COMPOSITOR FOR X"
    echo ""
    echo "Picom is a standalone compositor for X, and a fork of Compton. It's used to"
    echo "provide window transparency and shadows, as well as other visual effects."
    echo ""
    echo "Disabling Picom will remove these visual effects, which can improve"
    echo "performance on older systems. However, the performance impact is minimal on"
    echo "most modern systems, and the visual effects can enhance the user experience."
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Prompt the user for their choice to enable or disable Picom
    while true; do
        read -p "Do you want to enable Picom? (Y/N): " yn
        case $yn in
            [Yy]*)
                picom_option=1

                echo "Debug: User chose to enable Picom" >>/home/$the_user/debug.txt

                break
                ;;
            [Nn]*)
                picom_option=0

                echo "Debug: User chose not to enable Picom" >>/home/$the_user/debug.txt

                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

prompt_for_automatic_drivers() {
    clear
    echo "Debug: Displaying Automatic Driver Installation message" >>/home/$the_user/debug.txt

    # Display a message about automatic driver installation
    echo ""
    echo "///////////////////////////////////////////////////////////////////////////"
    echo "AUTOMATIC DRIVER INSTALLATION"
    echo ""
    echo "This option allows you to automatically find and install the best drivers"
    echo "for your system. This is recommended for most users, especially those who"
    echo "are new to Linux or have little experience with driver management."
    echo ""
    echo "The automatic system will use ubuntu-drivers to find and install the most"
    echo "suitable drivers for your hardware."
    echo ""
    echo "If you're an advanced user or have specific requirements, you can choose to"
    echo "manually install drivers later, but this may require additional knowledge"
    echo "and effort."
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Prompt the user for their choice to find and install the best drivers for their system automatically or not
    while true; do
        read -p "Do you want to automatically find and install system drivers? (Y/N): " yn
        case $yn in
            [Yy]*)
                automatic_drivers_option=1

                echo "Debug: User chose to automatically find and install system drivers" >>/home/$the_user/debug.txt

                break
                ;;
            [Nn]*)
                automatic_drivers_option=0

                echo "Debug: User chose not to automatically find and install system drivers" >>/home/$the_user/debug.txt

                break
                ;;
            *) echo "Please answer Y or N." ;;
        esac
    done
}

prompt_for_graphics_driver() {
    clear
    echo "Debug: Displaying Graphics Driver Menu" >>/home/$the_user/debug.txt

    # Display a message about graphics driver selection
    echo "///////////////////////////////////////////////////////////////////////////"
    echo "GRAPHICS DRIVER SELECTION"
    echo ""
    echo "This option allows you to choose the best graphics driver for your system."
    echo "1) AUTO-CONFIG: Lets the system automatically select and install the most suitable open-source drivers for your hardware."
    echo "2) NVIDIA (nouveau): Installs the open-source 'nouveau' drivers for NVIDIA GPUs."
    echo "3) AMD: Installs open-source drivers optimized for AMD GPUs."
    echo "4) Generic VESA Drivers: Installs generic VESA drivers. These should be replaced with proper drivers if available."
    echo "///////////////////////////////////////////////////////////////////////////"
    echo ""

    # Prompt the user for their choice of graphics driver
    while true; do
        echo "1) Auto-Config"
        echo "2) NVIDIA (nouveau)"
        echo "3) AMD"
        echo "4) Intel"
        echo "5) Generic VESA Drivers"
        read -p "Select your option (1-5): " option

        case $option in
            1)
                graphics_option="auto"

                echo "Debug: User chose to automatically find and install graphics drivers" >>/home/$the_user/debug.txt

                break
                ;;
            2)
                graphics_option="nvidia"

                echo "Debug: User chose to install NVIDIA (nouveau) drivers" >>/home/$the_user/debug.txt

                break
                ;;
            3)
                graphics_option="amd"

                echo "Debug: User chose to install AMD drivers" >>/home/$the_user/debug.txt

                break
                ;;
            4)
                graphics_option="intel"

                echo "Debug: User chose to install Intel drivers" >>/home/$the_user/debug.txt

                break
                ;;
            5)
                graphics_option="generic"

                echo "Debug: User chose to install generic VESA drivers" >>/home/$the_user/debug.txt

                break
                ;;
            *) echo "Please enter a valid option (1-5)." ;;
        esac
    done
}

auto_install_graphics_driver() {
    local gpu_info=$(lspci | grep -E "VGA|3D")

    # Check if gpu_info is empty
    if [ -z "$gpu_info" ]; then
        echo "No GPU detected. Exiting..." >>/home/$the_user/debug.txt

        exit 1
    fi

    if [[ $gpu_info == *"NVIDIA"* ]]; then
        echo "Debug: Automatically detected GPU: NVIDIA" >>/home/$the_user/debug.txt

        echo "NVIDIA GPU detected. Using nouveau drivers..."

        sudo apt install xserver-xorg-video-nouveau mesa-utils mesa-vulkan-drivers libgl1-mesa-dri libgl1-mesa-glx
    elif [[ $gpu_info == *"AMD"* ]]; then
        echo "Debug: Automatically detected GPU: AMD" >>/home/$the_user/debug.txt

        echo "AMD GPU detected. Installing AMD drivers..."

        sudo apt install mesa-utils mesa-vulkan-drivers mesa-vdpau-drivers libgl1-mesa-dri libgl1-mesa-glx
    elif [[ $gpu_info == *"Intel"* ]]; then
        echo "Debug: Automatically detected GPU: Intel" >>/home/$the_user/debug.txt

        echo "Intel GPU detected. Installing Intel drivers..."

        sudo apt install mesa-utils mesa-vulkan-drivers libgl1-mesa-dri libgl1-mesa-glx intel-media-va-driver

        echo "Debug: Automatic GPU detection failed. Installing generic VESA drivers (These should be replaced with proper drivers if available)" >>/home/$the_user/debug.txt

        echo "No specific GPU detected. Installing generic VESA drivers (These should be replaced with proper drivers if available)"

        sudo apt install xserver-xorg-video-vesa
    fi

    echo "Debug: Running X Configure" >>/home/$the_user/debug.txt

    sudo X -configure # This should be run outside of X session

    sudo mv /root/xorg.conf.new /etc/X11/xorg.conf
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

    echo "Debug: Performing initial update and upgrade" >>/home/$the_user/debug.txt

    # Initial Update and Upgrade
    sudo apt update -y && sudo apt upgrade -y

    echo "Debug: Installing software and libraries from Ubuntu" >>/home/$the_user/debug.txt

    local ubuntu_packages=(git build-essential libpam0g-dev libxcb1-dev xorg nano libgl1-mesa-dri lua5.3 vlc libgtk2.0-0 xterm pcmanfm pulseaudio pavucontrol gvfs-backends gvfs-fuse qtbase5-dev libqt5x11extras5-dev libqt5svg5-dev libhunspell-dev qttools5-dev-tools galculator lxrandr clamav clamav-daemon libtext-csv-perl libjson-perl gnome-icon-theme cron libcommon-sense-perl libencode-perl libjson-xs-perl libtext-csv-xs-perl libtypes-serialiser-perl libcairo-gobject-perl libcairo-perl libextutils-depends-perl libglib-object-introspection-perl libglib-perl libgtk3-perl libfont-freetype-perl libxml-libxml-perl inotify-tools acpi lxappearance iputils-ping dbus connman connman-doc cmst libimlib2 libqt5printsupport5 policykit-1 lxpolkit xarchiver qpdfview volumeicon-alsa gdebi jq arc-theme zenity alsa-utils chrony libgee-0.8-2 libgranite-common libgranite6 featherpad icewm xscreensaver-data-extra xscreensaver-gl-extra)
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

        install_packages freecol openttd openttd-opensfx pingus frogatto glew-utils libswt-gtk-4-java libportaudio2 fonts-ipafont-gothic fonts-ipafont-mincho fonts-indic fluid-soundfont-gm
    fi

    echo "Debug: Installing Printer Package" >>/home/$the_user/debug.txt

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

    # Check if the user wants to disable the ConnMan Wait for Network Service
    if [ "$connman_service_option" == "1" ]; then
        echo "Debug: Disabling ConnMan Wait for Network Service" >>/home/$the_user/debug.txt

        sudo systemctl stop connman-wait-online.service
        sudo systemctl disable connman-wait-online.service
    fi

    # Check if the user wants to enable Picom
    if [ "$picom_option" == "1" ]; then
        echo "Debug: Enabling Picom" >>/home/$the_user/debug.txt

        sudo apt install picom

        echo "Debug: Installing default picom configuration" >>/home/$the_user/debug.txt

        # Install default picom configuration
        wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Files/Configs/picom.conf
        mkdir -p /home/$the_user/.config/picom/
        sudo mv -f picom.conf /home/$the_user/.config/picom/picom.conf
        chmod 664 /home/$the_user/.config/picom/picom.conf
        chown $the_user:$the_user /home/$the_user/.config/picom/picom.conf
    fi

    # Check the user's choice for the graphics driver
    if [ "$graphics_option" == "auto" ]; then
        echo "Debug: Automatically determining drivers" >>/home/$the_user/debug.txt

        auto_install_graphics_driver
    elif [ "$graphics_option" == "nouveau" ]; then
        echo "Debug: Installing NVIDIA Drivers" >>/home/$the_user/debug.txt

        sudo apt install xserver-xorg-video-nouveau mesa-utils mesa-vulkan-drivers libgl1-mesa-dri libgl1-mesa-glx
    elif [ "$graphics_option" == "amd" ]; then
        echo "Debug: Installing AMD Drivers" >>/home/$the_user/debug.txt

        sudo apt install mesa-utils mesa-vulkan-drivers mesa-vdpau-drivers libgl1-mesa-dri libgl1-mesa-glx
    elif [ "$graphics_option" == "intel" ]; then
        echo "Debug: Installing Intel Drivers" >>/home/$the_user/debug.txt

        sudo apt install mesa-utils mesa-vulkan-drivers libgl1-mesa-dri libgl1-mesa-glx intel-media-va-driver
    elif [ "$graphics_option" == "generic" ]; then
        echo "Debug: Installing Generic Drivers (These should be replaced with proper drivers if available)" >>/home/$the_user/debug.txt

        sudo apt install xserver-xorg-video-vesa
    fi

    echo "Debug: Running X Configure" >>/home/$the_user/debug.txt

    sudo X -configure # This should be run outside of X session

    sudo mv /root/xorg.conf.new /etc/X11/xorg.conf

    echo "Debug: Downloading & Installing Software from .deb files" >>/home/$the_user/debug.txt

    # Download and Install Software from .deb files

    # Download and Install Latest ClamTk
    echo "Debug: Starting Download/Install of ClamTk" >>/home/$the_user/debug.txt
    wget -qO- "https://api.github.com/repos/dave-theunsub/clamtk/releases/latest" | jq -r '.assets[] | select(.name | endswith("all.deb")) | .browser_download_url' | xargs wget -O clamtk-latest.deb
    if [ ! -f "clamtk-latest.deb" ]; then
        echo "Debug: ERROR: Downloading the latest version of ClamTk failed. Trying fallback URL" >>/home/$the_user/debug.txt

        wget "https://github.com/dave-theunsub/clamtk/releases/download/v6.17/clamtk_6.17-1_all.deb" -O clamtk-latest.deb
    fi

    if [ -f "clamtk-latest.deb" ]; then
        sudo dpkg -i clamtk-latest.deb
        sudo apt-get -f install
        rm clamtk-latest.deb

        echo "Debug: ClamTk Successfully Installed!" >>/home/$the_user/debug.txt
    else
        echo "Debug: ERROR: Failed to download ClamTk" >>/home/$the_user/debug.txt

        exit 1
    fi

    # Download and Install Latest Min Browser
    echo "Debug: Starting Download/Install of Min Browser" >>/home/$the_user/debug.txt
    wget "https://github.com/minbrowser/min/releases/download/v1.31.2/min-1.31.2-amd64.deb" -O min-latest.deb
    if [ -f "min-latest.deb" ]; then
        sudo dpkg -i min-latest.deb
        sudo apt-get -f install
        rm min-latest.deb

        echo "Debug: Min Browser Successfully Installed! Configuring..." >>/home/$the_user/debug.txt

        # Set Min as the default browser
        sudo xdg-settings set default-web-browser min.desktop && sudo update-alternatives --config x-www-browser
    else
        echo "Debug: ERROR: Failed to download Min browser" >>/home/$the_user/debug.txt

        exit 1
    fi

    # Download and Install ParaPara Image Viewer
    echo "Debug: Starting Download/Install of ParaPara Image Viewer" >>/home/$the_user/debug.txt
    wget "https://github.com/aharotias2/parapara/releases/download/v3.2.10/parapara-3.2.10-1_x86-64.deb" -O parapara-latest.deb
    if [ -f "parapara-latest.deb" ]; then
        sudo dpkg -i parapara-latest.deb
        sudo apt-get -f install
        rm parapara-latest.deb

        echo "Debug: ParaPara Successfully Installed!" >>/home/$the_user/debug.txt
    else
        echo "Debug: ERROR: Failed to download ParaPara" >>/home/$the_user/debug.txt

        exit 1
    fi

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

    echo "Debug: Downloading default config files" >>/home/$the_user/debug.txt

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

    # Download configuration file for volumeicon
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Files/Configs/volumeicon
    mkdir -p /home/$the_user/.config/volumeicon/
    sudo mv -f volumeicon /home/$the_user/.config/volumeicon/volumeicon
    chmod 664 /home/$the_user/.config/volumeicon/volumeicon
    chown $the_user:$the_user /home/$the_user/.config/volumeicon/volumeicon

    # Download configuration file for the IceWM Toolbar
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Files/Configs/toolbar
    sudo mv -f toolbar /home/$the_user/.icewm/toolbar
    chmod 664 /home/$the_user/.icewm/toolbar
    chown $the_user:$the_user /home/$the_user/.icewm/toolbar

    # Download configuration file for default file type programs
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Files/Configs/mimeapps.list
    sudo mv -f mimeapps.list /home/$the_user/.config/mimeapps.list
    chmod 664 /home/$the_user/.config/mimeapps.list
    chown $the_user:$the_user /home/$the_user/.config/mimeapps.list

    # Download configuration files for system updater
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Files/Configs/system_updater.desktop
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Scripts/Utilities/system_updater
    sudo mv system_updater /usr/local/bin/system_updater
    sudo mv system_updater.desktop /usr/share/applications/system_updater.desktop
    sudo chmod 755 /usr/local/bin/system_updater
    sudo chmod 644 /usr/share/applications/system_updater.desktop

    # Download configuration file for resolved.conf
    wget -c https://github.com/VoxAndrews/Diet-Buntu/raw/main/Files/Configs/resolved.conf
    mkdir -p /etc/systemd/
    sudo mv -f resolved.conf /etc/systemd/resolved.conf
    sudo chmod 644 /etc/systemd/resolved.conf
    sudo chown root:root /etc/systemd/resolved.conf

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

    echo "Debug: Adding Startup Programs/Scripts" >>/home/$the_user/debug.txt

    # Add Programs/Scripts to Startup
    # .xsessionrc Process
    # Apply Resolution on Reboot/IceWM Restart
    echo "" >>/home/$the_user/.xsessionrc
    echo "# Extract the xrandr command from lxrandr-autostart.desktop" >>/home/$the_user/.xsessionrc
    echo "xrandr_command=\$(grep \"Exec=\" /home/$the_user/.config/autostart/lxrandr-autostart.desktop | cut -d\"'\" -f2)" >>/home/$the_user/.xsessionrc
    echo "" >>/home/$the_user/.xsessionrc
    echo "# Execute the extracted command" >>/home/$the_user/.xsessionrc
    echo "eval \$xrandr_command" >>/home/$the_user/.xsessionrc
    echo "" >>/home/$the_user/.xsessionrc

    echo "" >>/home/$the_user/.xsessionrc

    # Set the last resolution to the current resolution on startup (Used for the login screen)
    echo 'resolution=$(xrandr | grep "*" | awk "{print \$1}")  # Gets the current resolution' >>/home/$the_user/.xsessionrc
    echo 'echo $resolution > /var/lib/resolutions/current.resolution  # Stores the current resolution' >>/home/$the_user/.xsessionrc

    echo "" >>/home/$the_user/.xsessionrc

    # Add pcmanfm to startup
    echo "pcmanfm --desktop &" >>/home/$the_user/.xsessionrc

    # Add Daemon's to Startup
    echo "xscreensaver -nosplash &" >>/home/$the_user/.xsessionrc

    # Startup Programs/Scripts
    echo "/home/$the_user/.scripts/desktop_icon_scan.sh &" >>/home/$the_user/.xsessionrc
    echo "/usr/bin/lxpolkit &" >>/home/$the_user/.xsessionrc
    echo "cmst --minimized &" >>/home/$the_user/.xsessionrc
    echo "volumeicon &" >>/home/$the_user/.xsessionrc
    echo "picom &" >>/home/$the_user/.xsessionrc

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
        grep -q "gtk-theme-name=" $file && sudo sed -i 's/gtk-theme-name=.*/gtk-theme-name="Arc-Dark"/' $file || echo 'gtk-theme-name="Arc-Dark"' >>$file
    else
        # Create the file and add the lines
        touch $file
        echo "# Custom GTK 2.0 settings" >>$file
        echo 'gtk-icon-theme-name="Papirus-Dark"' >>$file
        echo 'gtk-theme-name="Arc-Dark"' >>$file
    fi

    echo "Debug: Updating and upgrading software" >>/home/$the_user/debug.txt

    # Update and Upgrade Software
    sudo apt update -y && sudo apt upgrade -y

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
    select_timezone

    if [ "$choice" == "y" ]; then
        prompt_for_themes_menu
        prompt_for_utility_software_package
        prompt_for_entertainment_package
        prompt_for_printer_package
        prompt_for_clamav_daemon
        prompt_for_connman_service
        prompt_for_picom_compositor
        prompt_for_automatic_drivers

        # Check whether the user wants to automatically install drivers or not
        if [ "$automatic_drivers_option" == "1" ]; then
            echo "Debug: Automatically installing drivers" >>/home/$the_user/debug.txt

            # Automatically install drivers
            sudo ubuntu-drivers autoinstall
        elif [ "$automatic_drivers_option" == "0" ]; then
            prompt_for_graphics_driver
        fi

        begin_installation
        exit_message
    else
        echo "Exiting the script..."
        exit 0
    fi
}

main
EOF
