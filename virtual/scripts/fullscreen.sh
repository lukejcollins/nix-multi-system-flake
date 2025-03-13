#!/bin/bash

# Check if any arguments were passed
if [ $# -eq 0 ]; then
  echo "Usage: $0 <window_name>"
  exit 1
fi

# Launch the app passed in as an argument then wait for it to launch
exec $1 &
sleep 3

# Use the passed argument as the window name
window_name="$1"

# Find all windows matching the window name
window_ids=$(xdotool search --name "$window_name")

# Check if any windows were found
if [ -z "$window_ids" ]; then
  echo "No windows found with the name '$window_name'"
  exit 1
fi

# Loop through all found window IDs and perform the operations
for window_id in $window_ids; do
  # Remove window borders
  xprop -id $window_id -f _MOTIF_WM_HINTS 32c -set _MOTIF_WM_HINTS "2, 0, 0, 0, 0"
done
