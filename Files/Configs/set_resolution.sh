#!/bin/bash

# Define log file location relative to the script location
script_dir=$(dirname "$0")
log_file="$script_dir/set_resolution.log"

# Define fallback resolution
fallback_resolution="1024x768"

# Path to the file where the resolution is stored
resolution_file="/var/lib/resolutions/current.resolution"

# Load the saved resolution or default to fallback
if [ -f "$resolution_file" ]; then
    resolution=$(cat "$resolution_file")
    echo "Found saved resolution: $resolution" >>$log_file
else
    echo "No saved resolution found. Using fallback resolution $fallback_resolution." >>$log_file
    resolution=$fallback_resolution
fi

# Find the first connected display
active_output=$(xrandr --query | grep " connected" | head -n 1 | awk '{ print $1 }')

echo "Active output detected: $active_output" >>$log_file

# Apply the resolution if supported, else apply the fallback resolution
if xrandr --query | awk -v output="$active_output" -v res="$resolution" '
BEGIN{ found=0 } 
$0 ~ output " connected" {inoutput = 1} 
inoutput && $0 ~ res {found=1} 
END{exit !found}
'; then
    # Apply the saved or default resolution
    echo "Applying resolution $resolution to $active_output" >>$log_file
    xrandr --output $active_output --mode $resolution
else
    # Apply the fallback resolution
    echo "Resolution $resolution not supported on $active_output. Applying fallback resolution $fallback_resolution." >>$log_file
    xrandr --output $active_output --mode $fallback_resolution
fi
