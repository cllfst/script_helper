#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Oracle VirtualBox Installation at $(date)" >> "$LOG_FILE"

installVirtualBox(){

    local system_release=$(cat /etc/issue)
    echo "What Ubuntu or Ubuntu-based version are you using ?"
    printc "CYAN" "Choose Your Linux Distribution : ( Distribution In Use -> '${system_release:0:-6}' )"
    echo "1. 24.04"
    echo "2. 22.04"
    echo "3. 20.04"
    echo -n "Choose Your Option : "
    read option
    log_message "INFO" "User chose option $option"

    case $option in
    1)
        log_message "INFO" "Downloading Oracle VM for Ubuntu or Ubuntu-Based 24.04"
        printc "YELLOW" "-> Downloading Oracle VM for Ubuntu or Ubuntu-Based 24.04..."
        sleep 1
        wget https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Ubuntu~noble_amd64.deb
        ;;
    2)
        log_message "INFO" "Downloading Oracle VM for Ubuntu or Ubuntu-Based 22.04"
        printc "YELLOW" "-> Downloading Oracle VM for Ubuntu or Ubuntu-Based 22.04..."
        sleep 1
        wget https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Ubuntu~jammy_amd64.deb
        ;;
    3)
        log_message "INFO" "Downloading Oracle VM for Ubuntu or Ubuntu-Based 20.04"
        printc "YELLOW" "-> Downloading Oracle VM for Ubuntu or Ubuntu-Based 20.04..."
        sleep 1
        wget https://download.virtualbox.org/virtualbox/7.1.4/virtualbox-7.1_7.1.4-165100~Ubuntu~focal_amd64.deb
        ;;
    *)
        log_message "WARN" "User chose wrong option : $option"
        invalidOption "installVirtualBox"
        ;;
    esac

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