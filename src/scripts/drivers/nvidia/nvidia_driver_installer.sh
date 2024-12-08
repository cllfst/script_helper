#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log


installDriver(){

    declare -A nvidiaVersions=(
    ["560"]=1
    ["550"]=1
    ["545"]=1
    ["535"]=1
    ["530"]=1
    ["525"]=1
    ["520"]=1
    ["515"]=1
    ["510"]=1
    ["470"]=1
    ["450"]=1
    ["390"]=1
    )
    
    while true; do

        printc "CYAN" "What NVIDIA Driver version do you want to install ?"
        echo "1. Show Available versions"
        echo -n "NVIDIA Driver Version [DEFAULT=560] : "
        read version
        log_message "INFO" "User selected option ${version}"

        if [[ "$version" == "1" ]]; then

            log_message "INFO" "Showing Available Version of NVIDIA Driver"
            echo "Available NVIDIA Version to Install :"
            for key in "${!nvidiaVersions[@]}"; do
                echo "$key"
            done
            echo -n "Press [ENTER] to continue..."
            read

        elif [[ "$version" == "" ]]; then

            log_message "INFO" "User chose the Default NVIDIA Driver Version"
            printc "YELLOW" "-> Installing NVIDIA Driver Version 560..."
            sudo apt install nvidia-driver-560 -y || handle_error "Failed to Install NVIDIA Driver 560"
            return

        elif [[ -v nvidiaVersions["$version"] ]]; then

            log_message "INFO" "User chose NVIDIA Driver Version ${version}"
            printc "YELLOW" "-> Installing NVIDIA Driver Version ${version}..."
            sudo apt install nvidia-driver-${version} -y || handle_error "Failed to Install NVIDIA Driver ${version}"
            return

        else

            log_message "WARN" "User chose invalid NVIDIA Driver Version : ${version}"
            invalidOption
            clear

        fi

    done

}

trap 'handle_error "An unexpected error occurred."' ERR

clear

echo "Continue script execution in NVIDIA Driver Installation at $(date)" >> "$LOG_FILE"
sleep 1
printc "CYAN" "NOTE : This Script Will Install Nvidia Driver Using 'graphics-drivers/ppa' Method"
echo -n "Press [ENTER] To Continue..."
read

printc "YELLOW" "-> Checking for Internet Connection..."
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with NVIDIA Driver Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with NVIDIA Driver Installation"

    log_message "INFO" "Purging Current NVIDIA Installation if Existed"
    printc "YELLOW" "-> Purging Current NVIDIA Installation if Existed..."
    sleep 1
    sudo apt autoremove nvidia* --purge -y || handle_error "Failed to Purge NVIDIA"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System"
    printc "YELLOW" "-> Updating System Packages..."
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Upgrade System Packages"

    log_message "INFO" "Installing Required Dependencies"
    printc "YELLOW" "-> Installing Required Dependencies..."
    sleep 1
    sudo apt install software-properties-common -y || handle_error "Failed To Install Required Dependencies"

    log_message "INFO" "Adding the graphics-drivers PPA"
    printc "YELLOW" "-> Adding the graphics-drivers PPA..."
    sleep 1
    sudo add-apt-repository ppa:graphics-drivers/ppa -y || handle_error "Failed to Add the graphics-drivers PPA"

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Installing NVIDIA Driver"
    printc "YELLOW" "-> Installing NVIDIA Driver..."
    sleep 1
    installDriver

    log_message "INFO" "NVIDIA Driver Installation Completed Successfully"
    echo -n -e "${GREEN}NVIDIA Driver Installation Completed Successfully.${RESET} Want to reboot now (Y/n) : "
    read a
    if [[ "$a" == "Y" || "$a" == "y" || "$a" == "" ]]; then
        echo "Reboot in 3 seconds..."
        reboot
    fi

else 

    handle_error "No Connection Available ! Exiting..."

fi 