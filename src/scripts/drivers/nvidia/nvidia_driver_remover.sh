#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in NVIDIA Driver Removing at $(date)" >> "$LOG_FILE"

log_message "INFO" "Checking for NVIDIA Driver Before Removing"
printc "YELLOW" "-> Checking for NVIDIA Driver Before Removing..."
sleep 1
if ! command -v nvidia-smi &> /dev/null; then

    log_message "INFO" "NVIDIA Driver is not installed. Exiting..."
    printc "RED" "NVIDIA Driver is not installed !"
    echo -n "Press [ENTER] To Exit Script..."
    read

else

    log_message "INFO" "NVIDIA Driver is installed. Continue..."
    printc "GREEN" "-> NVIDIA Driver is installed."
    echo -n "Press [ENTER] To Continue..."
    read

    log_message "INFO" "Removing NVIDIA Installation"
    printc "YELLOW" "-> Removing Current NVIDIA Installation..."
    sleep 1
    sudo apt autoremove nvidia* --purge -y || handle_error "Failed to Remove NVIDIA Driver"

    log_message "INFO" "NVIDIA Driver Removed Successfully"
    echo -n -e "${GREEN}NVIDIA Driver Removed Successfully.${RESET} Want to reboot now (Y/n) : "
    read a
    if [[ "$a" == "Y" || "$a" == "y" || "$a" == "" ]]; then
        echo "Reboot in 3 seconds..."
        reboot
    else
        echo -n "Press [ENTER] To Exit Script..."
        read
    fi

fi