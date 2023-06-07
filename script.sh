#!/bin/bash

IP_FILE="/home/fadi/ips.txt"

# Check if script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Read IP addresses from file and block traffic using iptables
while read IP; do
    iptables -A INPUT -s "$IP" -j DROP
done < "$IP_FILE"
