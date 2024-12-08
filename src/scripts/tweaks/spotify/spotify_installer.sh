#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Spotify Installation at $(date)" >> "$LOG_FILE"

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Spotify Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Spotify Installation..."
    sleep 1

    log_message "INFO" "fetching the security key"
    printc "YELLOW" "-> Fetching the security key..."
    sleep 1 
    curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg || handle_error "Failed to Fetch Spotify Security Key"

    log_message "INFO" "Adding Spotify APT Repository"
    printc "YELLOW" "-> Adding Spotify APT Repository..."
    sleep 1
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list || handle_error "Failed to Add Spotify APT Repository"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Spotify"
    printc "YELLOW" "-> Installing Spotify..."
    sleep 1
    sudo apt install spotify-client -y || handle_error "Failed to Install Spotify"

    log_message "INFO" "Installing Spotify Ad Blocker"
    printc "YELLOW" "-> Installing Spotify Ad Blocker..."
    sleep 1
    bash <(curl -sSL https://spotx-official.github.io/run.sh) -f || handle_error "Failed to Install Spotify Ad Blocker"
    printc "GREEN" "-> Spotify Ad Blocker Installed Successfully..."
    echo -e "Credits for ${CYAN}https://github.com/SpotX-Official/SpotX-Bash${RESET} for the Ad Blocker"

    echo "Spotify Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Spotify Installed Successfully"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi

