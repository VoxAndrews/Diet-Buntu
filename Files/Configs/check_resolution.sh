#!/bin/bash

# Define log file location relative to the script location
script_dir=$(dirname "$0")
log_file="$script_dir/check_resolution.log"

# Path to the file where the resolution is stored
resolution_file="/var/lib/resolutions/current.resolution"

# Log start of script
echo "Checking resolution at $(date)" >>$log_file

# Find the first connected display
active_output=$(xrandr --query | grep " connected" | head -n 1 | awk '{ print $1 }')

# If no active output is found, log and exit
if [ -z "$active_output" ]; then
    echo "No active output found. Exiting." >>$log_file
    exit 1
fi

# If the resolution file exists, read and verify the resolution
if [ -f "$resolution_file" ]; then
    saved_resolution=$(cat "$resolution_file")
    if xrandr | grep $active_output -A10 | grep "$saved_resolution" >/dev/null; then
        echo "Resolution $saved_resolution is supported on $active_output." >>$log_file
        exit 0
    else
        echo "Resolution $saved_resolution is not supported on $active_output." >>$log_file
        exit 2
    fi
else
    echo "No saved resolution found." >>$log_file
    exit 1
fi
