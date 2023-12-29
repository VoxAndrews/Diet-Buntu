#!/bin/bash

# Define the desktop directory and applications directory
desktop_dir="$HOME/Desktop"
applications_dir="/usr/share/applications"

# List of files to exclude
exclude=("snapd-user-session-agent.desktop" "snap-handler.desktop" "gnome-mimeapps.list" "additional-drivers.desktop" "defaults.list" "mimeinfo.cache" "gcr-prompter.desktop" "software-properties-drivers.desktop" "snap-handle-link.desktop" "openjdk-11-java.desktop" "python3.10.desktop" "io.snapcraft.SessionAgent.desktop" "gnome-software-local-file.desktop" "gcr-viewer.desktop" "openstreetmap-geo-handler.desktop" "hplj1020.desktop" "wheelmap-geo-handler.desktop" "google-maps-geo-handler.desktop" "qwant-maps-geo-handler.desktop" "org.kde.kwalletd5.desktop" "software-properties-livepatch.desktop" "info.desktop" "synaptic.desktop" "debian-uxterm.desktop" "gdebi.desktop")

# Function to update desktop icons
update_icons() {
    # Remove all symbolic links from the desktop directory
    find "$desktop_dir" -type l -exec rm {} \;

    # Create new symbolic links
    for app in "$applications_dir"/*.desktop; do
        # Extract the filename from the path
        filename=$(basename "$app")

        # Check if the file is in the exclude list
        if [[ ! " ${exclude[@]} " =~ " ${filename} " ]]; then
            ln -s "$app" "$desktop_dir"
        fi
    done
}

# Initial update
update_icons

# Monitor the applications directory for changes
inotifywait -m -e create,delete,modify,moved_to,moved_from "$applications_dir" | while read -r directory events filename; do
    if [[ "$filename" == *.desktop ]]; then
        update_icons
    fi
done
EOF
