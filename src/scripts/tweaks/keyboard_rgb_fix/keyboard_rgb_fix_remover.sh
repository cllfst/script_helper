#!/usr/bin/env bash

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Keyboard RGB Backlight Fixer Removing at $(date)" >> "$LOG_FILE"
sleep 1

log_message "INFO" "Removing Keyboard RGB Backlight Fixer Installation"
printc "YELLOW" "-> Removing Keyboard RGB Backlight Fixer Installation..."
sleep 1

if [[ -d ~/clevo-keyboard/ && -f ~/kb.sh ]]; then
    sudo rm -rf ~/clevo-keyboard/
    rm ~/kb.sh
    printc "GREEN" "-> Keyboard RGB Backlight Fixer Installation Removed Successfully..."
    echo "PRESS [ENTER] To Exit Script..."
    read
else
    printc "YELLOW" "-> No Keyboard RGB Backlight Fixer Installation Found !..."
    echo "PRESS [ENTER] To Exit Script..."
    read
fi