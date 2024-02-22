#!/bin/bash

# Define the desktop directory and applications directory
desktop_dir="$HOME/Desktop"
applications_dir="/usr/share/applications"

# List of files to exclude
exclude=("snapd-user-session-agent.desktop" "snap-handler.desktop" "gnome-mimeapps.list" "additional-drivers.desktop" "defaults.list" "mimeinfo.cache" "gcr-prompter.desktop" "software-properties-drivers.desktop" "snap-handle-link.desktop" "openjdk-11-java.desktop" "python3.10.desktop" "io.snapcraft.SessionAgent.desktop" "gnome-software-local-file.desktop" "gcr-viewer.desktop" "openstreetmap-geo-handler.desktop" "hplj1020.desktop" "wheelmap-geo-handler.desktop" "google-maps-geo-handler.desktop" "qwant-maps-geo-handler.desktop" "org.kde.kwalletd5.desktop" "software-properties-livepatch.desktop" "info.desktop" "synaptic.desktop" "debian-uxterm.desktop" "gdebi.desktop" "picom.desktop")

# Function to update desktop icons
update_icons() {
    # Remove all symbolic links from the desktop directory
    find "$desktop_dir" -type l -exec rm {} \;

    # Create new symbolic links from system applications directory
    for app in "$applications_dir"/*.desktop; do
        create_link "$app"
    done
}

# Function to create a symbolic link if the file is not excluded
create_link() {
    app=$1
    filename=$(basename "$app")
    if [[ ! " ${exclude[@]} " =~ " ${filename} " ]]; then
        ln -s "$app" "$desktop_dir"
    fi
}

# Initial update
update_icons

# Function to monitor a directory
monitor_directory() {
    directory_to_monitor=$1
    inotifywait -m -e create,delete,modify,moved_to,moved_from "$directory_to_monitor" | while read -r directory events filename; do
        if [[ "$filename" == *.desktop ]]; then
            update_icons
        fi
    done
}

# Monitor both directories in the background
monitor_directory "$applications_dir" &
EOF
