#!/usr/bin/env bash

# External Functions/Files
source $(pwd)/src/utils.sh

# Show System Tweaks Menu
showSystemTweaksMenu(){
    clear
    log_message "INFO" "Displaying System Tweaks Menu"
    showMenu \
    "         System Tweaks Menu" \
    "Install PipeWire Sound System" \
    "Fix Keyboard RGB backlight" \
    "Install Spotify" \
    "Install Wine (Run Windows Apps for Linux)" \
    "Return to Previous Menu"
    
    echo -n "Enter Option : "
    read option
    log_message "INFO" "User selected option $option in System Tweaks Menu"

    case $option in
        1)
            showPipeWireMenu
            ;;
        2)
            showFixKeyboardRGB
            ;;
        3) 
            showSpotifyMenu
            ;;
        4)
            showWineMenu
            ;;
        5)
            log_message "INFO" "User chose to Return to Previous Menu"
            showMainMenu
            ;;
        *)
            log_message "WARN" "User chose an invalid option : $option"
            invalidOption showSystemTweaksMenu
            ;;
    esac
}

showPipeWireMenu(){
    log_message "INFO" "User chose to Install PipeWire Sound System"
    log_message "INFO" "Displaying PipeWire Sound System Menu"
    optionMenu "             PipeWire Sound System" \
       "${scriptPaths["pipewire_installer"]}" \
       "" \
       "showSystemTweaksMenu"
}

showFixKeyboardRGB(){
    log_message "INFO" "User chose To Fix Keyboard RGB Backlight"
    log_message "INFO" "Displaying Fix Keyboard RGB Backlight Menu"
    optionMenu "           Fix Keyboard RGB Backlight" \
       "${scriptPaths["keyboard_rgb_fix_installer"]}" \
       "${scriptPaths["keyboard_rgb_fix_remover"]}" \
       "showSystemTweaksMenu"
}

showSpotifyMenu(){
    log_message "INFO" "User chose to Install Spotify"
    log_message "INFO" "Displaying Spotify Menu"
    optionMenu "              Spotify + Ad Blocker" \
       "${scriptPaths["spotify_installer"]}" \
       "${scriptPaths["spotify_remover"]}" \
       "showSystemTweaksMenu"
}

showWineMenu(){
    log_message "INFO" "User chose to Install Wine"
    log_message "INFO" "Displaying Wine Menu"
    optionMenu "                     Wine" \
       "${scriptPaths["wine_installer"]}" \
       "${scriptPaths["wine_remover"]}" \
       "showSystemTweaksMenu"    
}