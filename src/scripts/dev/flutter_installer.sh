#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Flutter SDK Installation at $(date)" >> "$LOG_FILE"

installFlutter(){

    declare -A flutterVersions=(
        ["3.24.5"]=1
        ["3.24.4"]=1
        ["3.24.3"]=1
        ["3.24.2"]=1
        ["3.24.1"]=1
        ["3.24.0"]=1
        ["3.22.3"]=1
        ["3.22.2"]=1
        ["3.22.1"]=1
        ["3.22.0"]=1
        ["3.19.6"]=1
        ["3.19.5"]=1
        ["3.19.4"]=1
        ["3.19.3"]=1
        ["3.19.2"]=1
        ["3.19.1"]=1
        ["3.19.0"]=1
    )
    while true; do

        echo -n -e "${CYAN}Install the Latest Flutter SDK Version ? (Y/n) :${RESET} "
        read option
        log_message "INFO" "User chose option $option"

        if [[ "$option" == "Y" || "$option" == "y" || "$option" == "" ]]; then

            log_message "INFO" "User Chose to Install The Latest Flutter version"

            log_message "INFO" "Downloading Flutter SDK 3.24.5"
            printc "YELLOW" "-> Downloading Flutter SDK 3.24.5..."
            sleep 1

            if [[ -f $(pwd)/flutter_linux_3.24.5-stable.tar.xz ]]; then
                rm $(pwd)/flutter_linux_3.24.5-stable.tar.xz
            fi

            wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz || handle_error "Failed to Download Flutter SDK"

            log_message "INFO" "Extracting Flutter SDK to ~/"
            printc "YELLOW" "-> Extracting Flutter SDK to ~/"
            sleep 1
            tar -xvf flutter_linux_3.24.5-stable.tar.xz -C ~/ || handle_error "Failed to Extract Flutter SDK to ~/"
            return

        elif [[ "$option" == "n" || "$option" == "N" ]]; then

            log_message "INFO" "User Chose to Install an Another Flutter Version"

            printc "CYAN" "What Flutter Version do you want to install ?"
            echo "1. Show Versions"
            echo -n "Select Option/Version : "
            read ov
            log_message "INFO" "User chose option/version $ov"

            if [[ "$ov" == "1" ]]; then

                log_message "INFO" "Printing Flutter Versions"
                for key in "${!flutterVersions[@]}"; do
                    echo "Flutter SDK Version : $key"
                done
                echo -n "Press [ENTER] to continue..."
                read

            elif [[ -v flutterVersions["$ov"] ]]; then
                log_message "INFO" "User chose to install flutter version $ov"

                log_message "INFO" "Downloading Flutter SDK version $ov"
                printc "YELLOW" "-> Downloading Flutter SDK $ov..."
                sleep 1

                if [[ -f $(pwd)/flutter_linux_$ov-stable.tar.xz ]]; then
                    rm $(pwd)/flutter_linux_$ov-stable.tar.xz
                fi

                wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$ov-stable.tar.xz || handle_error "Failed to Download Flutter SDK version $ov"

                log_message "INFO" "Extracting Flutter SDK to ~/"
                printc "YELLOW" "-> Extracting Flutter SDK to ~/"
                sleep 1
                tar -xvf flutter_linux_$ov-stable.tar.xz -C ~/ || handle_error "Failed to Extract Flutter SDK to ~/"
                return

            else

                log_message "WARN" "User chose a wrong version : $ov"
                printc "RED" "Wrong Flutter SDK Version Selected !"
                echo "Press [ENTER] to Continue"
                read

            fi

        else

            log_message "WARN" "User chose a wrong option : $option"
            invalidOption

        fi

    done

}

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

    log_message "INFO" "Internet Connection Detected. Proceeding with Flutter SDK Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Flutter SDK Installation..."
    sleep 1

    log_message "INFO" "Refreshing Package Cache"
    printc "YELLOW" "-> Refreshing Package Cache..."
    sleep 1
    sudo apt update || handle_error "Failed to Refresh Package Cache"

    log_message "INFO" "Updating System Packages"
    printc "YELLOW" "-> Updating System Packages..."
    sleep 1
    sudo apt upgrade -y || handle_error "Failed to Update System Packages"

    log_message "INFO" "Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa"
    printc "YELLOW" "-> Installing the following packages: curl, git, unzip, xz-utils, zip, libglu1-mesa..."
    sleep 1
    sudo apt install -y curl git unzip xz-utils zip libglu1-mesa || handle_error "Failed to Install Required Packages"

    installFlutter

    log_message "INFO" "Removing Old Flutter PATH if Existed"
    printc "YELLOW" "-> Removing Old Flutter PATH if Existed..."
    grep -l 'flutter/bin' ~/.bashrc | xargs -I {} sed -i '/flutter\/bin/d' {}

    log_message "INFO" "Adding Flutter to PATH (bash)"
    printc "YELLOW" "-> Adding Flutter to PATH (bash)..."
    sleep 1
    echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc || handle_error "Failed to Add Flutter to PATH (bash)"

    log_message "Activating Flutter"
    printc "YELLOW" "-> Activating Flutter..."
    sleep 1
    source ~/.bashrc || handle_error "Failed to Activate Flutter"

    log_message "Executing flutter doctor -v"
    printc "YELLOW" "-> Executing flutter doctor -v (It May Take a Little While)"
    sleep 1
    flutter doctor -v || handle_error "Failed to Execute flutter doctor -v"

    log_message "INFO" "Flutter SDK Installer Script Completed Successfully"
    printc "GREEN" "-> Flutter SDK Installer Script Completed Successfully..."
    echo "Press [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi