#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log
CODENAME=$(. /etc/os-release && echo "$UBUNTU_CODENAME")


trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Wine Installation at $(date)" >> "$LOG_FILE"

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Wine Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Wine Installation..."
    sleep 1

    log_message "INFO" "Enabling 32-bit Architecture"
    printc "YELLOW" "-> Enabling 32-bit Architecture..."
    sleep 1
    sudo dpkg --add-architecture i386 || handle_error "Failed to Enable 32-bit Architecture"

    log_message "INFO" "Downloading Wine Repository"
    printc "YELLOW" "-> Downloading Wine Repository..."
    sleep 1
    sudo mkdir -pm755 /etc/apt/keyrings
    wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key - || handle_error "Failed to Download Wine Repository"

    log_message "INFO" "Adding Wine Repository"
    printc "YELLOW" "-> Adding Wine Repository..."
    sleep 1
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/${CODENAME}/winehq-${CODENAME}.sources || handle_error "Failed to Add Wine Repository"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing Wine Development branch"
    printc "YELLOW" "-> Installing Wine Development branch..."
    sleep 1
    sudo apt install --install-recommends winehq-devel -y || handle_error "Failed to Install Wine"

    log_message "INFO" "Printing Installed Wine Version"
    printc "YELLOW" "-> Printing Installed Wine Version..."
    sleep 1
    wine --version || handle_error "Failed to Print Installed Wine Version"

    echo "Wine Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Wine Installed Successfully"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi