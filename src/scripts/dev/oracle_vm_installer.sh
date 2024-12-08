#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Oracle VirtualBox Installation at $(date)" >> "$LOG_FILE"

installVirtualBox(){

    local system_release=$(cat /etc/issue)
    local CODENAME=$(. /etc/os-release && echo "$UBUNTU_CODENAME")

    log_message "WARN" "Warn User about System Requirement"
    printc "YELLOW" "NOTE : Your System Must be Ubuntu or Ubuntu-Based >= 20.04"
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Downloading Oracle VM for ${system_release:0:-6}"
    printc "YELLOW" "-> Downloading Oracle VM for ${system_release:0:-6}..."
    sleep 1

    if [[ -f $(pwd)/virtualbox-7.1_7.1.4-165100~Ubuntu~${CODENAME}_amd64.deb ]]; then
        rm $(pwd)/virtualbox-7.1_7.1.4-165100~Ubuntu~${CODENAME}_amd64.deb
    fi

    wget https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Ubuntu~${CODENAME}_amd64.deb

    log_message "INFO" "Installing Oracle VM"
    printc "YELLOW" "-> Installing Oracle VM..."
    sleep 1
    sudo apt install libxcb-cursor0 || handle_error "Failed to Install Required Package"
    sudo dpkg -i virtualbox-7.1*.deb
    sudo apt --fix-broken install -y || handle_error "Failed to install Oracle VM"

    echo "Oracle VirtualBox Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Oracle VirtualBox Installed Successfully..."
    echo "PRESS [ENTER] to exit..."
    read
}

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Oracle VirtualBox Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Oracle VirtualBox Installation..."
    sleep 1

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    installVirtualBox

else

    handle_error "No Internet Connection Available, Exiting..."

fi