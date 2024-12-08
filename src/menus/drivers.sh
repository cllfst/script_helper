#!/usr/bin/env bash

# External Functions/Files
source $(pwd)/src/utils.sh

showDriversMenu(){

    clear
    log_message "INFO" "Displaying Drivers Menu"
    showMenu \
    "         Drivers Menu" \
    "Install NVIDIA Driver" \
    "Install NVIDIA CUDA Toolkit" \
    "CUDA Version Switcher" \
    "Return to Previous Menu"

    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in Drivers Menu"

    case $option in

    1)
        log_message "INFO" "User chose to install NVIDIA Driver"
        showNVIDIADriverMenu
        ;;
    2)
        log_message "INFO" "User chose to install NVIDIA CUDA Toolkit"
        showNVIDIACUDAMenu
        ;;
    3)
        log_message "INFO" "User chose to use CUDA Switcher"
        bash "${scriptPaths["cuda_switcher"]}"
        ;;

    4)
        log_message "INFO" "User chose to return to Previous Menu"
        showMainMenu
        ;;
    *)
        log_message "WARN" "User chose an invalid option : $option"
        invalidOption showDriversMenu
        ;;

    esac

}

showNVIDIADriverMenu(){
    log_message "INFO" "Displaying NVIDIA Driver Menu"
    optionMenu "                 NVIDIA Driver" \
               "${scriptPaths["nvidia_driver_installer"]}" \
               "${scriptPaths["nvidia_driver_remover"]}" \
               "showDriversMenu"   
}

showNVIDIACUDAMenu(){
    log_message "INFO" "Displaying NVIDIA CUDA Toolkit Menu"
    optionMenu "               NVIDIA CUDA Toolkit" \
               "${scriptPaths["cuda_installer"]}" \
               "" \
               "showDriversMenu"
}