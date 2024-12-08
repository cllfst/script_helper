#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Conda Installation at $(date)" >> "$LOG_FILE"

while true; do

    printc "CYAN" "What Conda Distribution do you want to Remove ?"
    echo "1. Miniconda"
    echo "2. Anaconda"
    echo -n "Your Option : "
    read option
    log_message "INFO" "User chose option $option"
    case $option in
        1)
            log_message "INFO" "Searching for Miniconda"
            printc "YELLOW" "-> Searching for Miniconda..."
            sleep 1
            minicondaPath=$(sudo find $HOME -type d -iname "miniconda*")
            if [[ "$minicondaPath" == "" ]]; then

                log_message "INFO" "No Miniconda Installation Found !"
                printc "YELLOW" "No Miniconda Installation Found !"
                echo -n "Press [ENTER] to Exit Script..."
                read

            else 

                log_message "INFO" "Found Miniconda Installation"
                printc "GREEN" "Found :"
                echo $minicondaPath  
                echo -n "Press [ENTER] to Continue..."
                read
                log_message "INFO" "Deleting Miniconda"
                printc "YELLOW" "-> Deleting Miniconda..."
                sleep 1
                rm -rf $minicondaPath

                printc "GREEN" "-> Miniconda Deleted Successfully"
                printc "YELLOW" "Close and Re-open the Terminal For Changes to be Taken !"
                echo -n "Press [ENTER] to Exit Script..."
                read

            fi
            break
            ;;
        2)
            log_message "INFO" "Searching for Anaconda"
            printc "YELLOW" "-> Searching for Anaconda..."
            sleep 1
            anacondaPath=$(sudo find $HOME -type d -iname "anaconda*")

            if [[ "$anacondaPath" == "" ]]; then

                log_message "INFO" "No Anaconda Installation Found"
                printc "YELLOW" "No Anaconda Installation Found !"
                echo -n "Press [ENTER] to Exit Script..."
                read

            else
                log_message "INFO" "Found Anaconda Installation"
                printc "GREEN" "Found : "
                echo $anacondaPath
                echo -n "Press [ENTER] to Continue..."
                read

                log_message "INFO" "Deleting Anaconda"
                printc "YELLOW" "-> Deleting Anaconda..."
                sleep 1
                rm -rf $anacondaPath

                printc "GREEN" "-> Anaconda Deleted Successfully"
                printc "YELLOW" "Close and Re-open the Terminal For Changes to be Taken !"
                echo -n "Press [ENTER] to Exit Script..."
                read

            fi
            break
            ;;
        *)
            invalidOption
            clear
            ;;
    esac

done