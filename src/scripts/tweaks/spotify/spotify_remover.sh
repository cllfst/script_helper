#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Spotify Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for Spotify Before Removing"
printc "YELLOW" "-> Checking for Spotify Before Removing..."
sleep 1

if ! command -v spotify &> /dev/null; then

    log_message "INFO" "Spotify is not installed. Exiting..."
    printc "RED" "Spotify is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "Spotify is installed. Continue..."
    printc "GREEN" "-> Spotify is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing Spotify Installation"
    printc "YELLOW" "-> Removing Spotify Installation..."
    sleep 1
    sudo apt autoremove spotify-client --purge -y || handle_error "Failed to Remove Spotify"

    log_message "INFO" "Removing Spotify Directory"
    printc "YELLOW" "-> Removing Spotify Directory..."
    sleep 1
    sudo rm -rf /usr/share/spotify

    echo "Spotify Remover Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Spotify Removed Successfully..."
    echo -n "Press [ENTER] To Exit Script..."
    read
fi