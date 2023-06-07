#!/bin/bash

# Path to the Firefox profile directory
profile_dir="/home/fadi/.mozilla/firefox/yhsq1i84.default-esr"

# Path to the web history output file
output_file="$HOME/web_history.txt"

# Get the username of the Linux account
username=$(whoami)

# Loop indefinitely
while true; do
  # Wait for 3 seconds before checking the history again
  sleep 3
  # Read the last 10 lines from the Firefox history file
  urls=$(sqlite3 "$profile_dir/places.sqlite" "SELECT datetime(moz_historyvisits.visit_date/1000000,'unixepoch') || '|' || moz_places.url FROM moz_places, moz_historyvisits WHERE moz_places.id = moz_historyvisits.place_id ORDER BY moz_historyvisits.visit_date DESC LIMIT 10;")

  # Loop over each URL
  while read -r url; do
    # Extract the date and time from the URL
    datetime=$(echo "$url" | cut -d'|' -f1)

    # Extract the URL from the URL
    url=$(echo "$url" | cut -d'|' -f2)

    # Check if the URL is already in the web history file
    if ! grep -q "$url" "$output_file"; then
      # If the URL is not in the web history file, append it to the end of the file with the date, time, and username
      echo " $username | $url | $datetime |" >> "$output_file"
    fi
  done <<< "$urls"
done
