#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Wine Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Wine Before Removing"
printc "YELLOW" "-> Checking for Wine Before Removing..."
sleep 1

if ! command -v wine &> /dev/null; then

    log_message "INFO" "Wine is not installed. Exiting..."
    printc "RED" "Wine is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "Wine is installed. Continue..."
    printc "GREEN" "-> Wine is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing Wine Installation"
    printc "YELLOW" "-> Removing Wine Installation..."
    sleep 1
    sudo apt autoremove winehq-devel --purge -y || handle_error "Failed to Remove Spotify"

    echo "Wine Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Wine Removed Successfully..."
    echo -n "Press [ENTER] To Exit Script..."
    read
fi