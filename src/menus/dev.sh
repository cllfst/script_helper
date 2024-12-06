#!/bin/bash

# External Functions/Files
source $(pwd)/src/utils.sh

# Show Development Menu
showDevelopmentMenu(){
    clear
    log_message "INFO" "Displaying Development Menu"
    showMenu \
    "         Development Menu" \
    "Install Angular CLI" \
    "Install Android Studio" \
    "Setup Flutter" \
    "Install Oracle VirtualBox" \
    "Install Docker" \
    "Return to Previous Menu"

    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in Development Menu"

    case $option in
        1)
            log_message "INFO" "User chose to Install Angular CLI"
            showAngularMenu
            ;;
        2)
            log_message "INFO" "User chose to Install Android Studio"
            showAndroidStudioMenu
            ;;
        3)
            log_message "INFO" "User chose to setup flutter"
            showFlutterMenu
            ;;
        4)
            log_message "INFO" "User chose to install Oracle VirtualBox"
            showVirtualBoxMenu
            ;;
        5)
            log_message "INFO" "User chose to install Docker"
            showDockerMenu
            ;;
        6)
            log_message "INFO" "User chose To Return to Main Menu"
            showMainMenu
            ;;
        *)
            log_message "WARN" "User chose an invalid option : $option"
            invalidOption showDevelopmentMenu
            ;;
    esac
}

showAngularMenu(){
    log_message "INFO" "Displaying Angular Menu"
    optionMenu "                    Angular" \
               "${scriptPaths["angular_installer"]}" \
               "" \
               "showDevelopmentMenu"
}

showAndroidStudioMenu(){
    log_message "INFO" "Displaying Android Studio Menu"
    optionMenu "                Android Studio" \
               "${scriptPaths["android_studio_installer"]}" \
               "" \
               "showDevelopmentMenu"

}

showFlutterMenu(){
    log_message "INFO" "Displaying Flutter Menu"
    optionMenu "                    Flutter" \
               "${scriptPaths["flutter_installer"]}" \
               "" \
               "showDevelopmentMenu"   
}
showVirtualBoxMenu(){
    log_message "INFO" "Displaying Flutter Menu"
    optionMenu "               Oracle VirtualBox" \
               "${scriptPaths["oracle_vm_installer"]}" \
               "" \
               "showDevelopmentMenu"    
}
showDockerMenu(){
    log_message "INFO" "Displaying Docker Menu"
    optionMenu "                    Docker" \
               "${scriptPaths["docker_installer"]}" \
               "${scriptPaths["docker_remover"]}" \
               "showDevelopmentMenu" 
}