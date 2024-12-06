#!/bin/bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Conda Installation at $(date)" >> "$LOG_FILE"

installMiniConda(){

    log_message "INFO" "Downloading Latest Miniconda Package"
    printc "YELLOW" "-> Downloading Latest Miniconda Package..."
    sleep 1
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh || handle_error "Failed to Download Latest Miniconda Package"

    log_message "INFO" "Making the Miniconda3 Package Executable"
    printc "YELLOW" "-> Making the Miniconda3 Package Executable..."
    sleep 1
    chmod +x Miniconda3-latest-Linux-x86_64.sh || handle_error "Failed to Make the Miniconda3 Package Executable"

    log_message "INFO" "Installing Miniconda3 to $HOME/miniconda3 in Silent Mode"
    printc "YELLOW" "-> Installing Miniconda3 to $HOME/miniconda3 in Silent Mode..."
    sleep 1
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda3 || handle_error "Failed to Install Miniconda3 to $HOME/miniconda3 in Silent Mode"

    log_message "INFO" "Activating Conda to Current SHELL Session"
    printc "YELLOW" "-> Activating Conda to Current SHELL..."
    sleep 1
    eval "$(/$HOME/miniconda3/bin/conda shell.bash hook)" || handle_error "Failed to Activate Conda to Current SHELL"

    log_message "INFO" "Installing Conda's Shell Functions"
    printc "YELLOW" "-> Installing Conda's Shell Functions..."
    sleep 1
    conda init || handle_error "Failed to Install Conda's Shell Functions"

}

installAnaConda(){

    log_message "INFO" "Downloading Latest Anaconda Package"
    printc "YELLOW" "-> Downloading Latest Anaconda Package..."
    sleep 1
    wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh || handle_error "Failed to Download Latest Anaconda Package"

    log_message "INFO" "Making the Anaconda Package Executable"
    printc "YELLOW" "-> Making the Anaconda Package Executable..."
    sleep 1
    chmod +x Anaconda3-2024.10-1-Linux-x86_64.sh || handle_error "Failed to Make the Anaconda Package Executable"

    log_message "INFO" "Installing Anaconda to $HOME/anaconda in Silent Mode"
    printc "YELLOW" "-> Installing Anaconda3 to $HOME/anaconda in Silent Mode..."
    sleep 1
    bash Anaconda3-2024.10-1-Linux-x86_64.sh -b -p $HOME/anaconda || handle_error "Failed to Install Anaconda3 to $HOME/anaconda in Silent Mode"

    log_message "INFO" "Activating AnaConda to Current SHELL Session"
    printc "YELLOW" "-> Activating AnaConda to Current SHELL..."
    sleep 1
    eval "$(/$HOME/anaconda/bin/conda shell.bash hook)" || handle_error "Failed to Activate AnaConda to Current SHELL"

    log_message "INFO" "Installing AnaConda's Shell Functions"
    printc "YELLOW" "-> Installing Conda's Shell Functions..."
    sleep 1
    conda init || handle_error "Failed to Install Conda's Shell Functions"

}

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1
if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Conda Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Conda Installation..."
    sleep 1

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    while true; do

        printc "CYAN" "-> Select Your Conda Version : "
        echo "1. Miniconda ( Minimal Installer ~ 120MB Download Size )" 
        echo "2. Anaconda  ( Larger Distribution ~ 1GB Download Size )"
        echo -n "Version to Install : "
        read option
        if [[ "$option" == "1" ]]; then
            installMiniConda
            break
        elif [[ "$option" == "2" ]]; then
            installAnaConda
            break
        else
            invalidOption
        fi

    done

    echo "Conda Script Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "-> Conda Script Completed Successfully"
    echo "Press [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi

