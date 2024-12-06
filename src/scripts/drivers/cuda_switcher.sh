#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in CUDA Switcher at $(date)" >> "$LOG_FILE"

printc "RED" "This script is used ONLY when the CUDA Toolkit is installed using the runfile Method !"
echo "Press [ENTER] to Continue..."
read

printc "YELLOW" "Assuming the CUDA Toolkit is Installed in the default path (/usr/local/)..."
sleep 1

log_message "INFO" "Printing Available CUDA Versions"
printc "CYAN" "-> Available CUDA Version : (IGNORE the \"cuda\" option)"
ls /usr/local | grep "cuda-*"

echo -n "Choose from the available option : "
read version
log_message "INFO" "User chose $version"

log_message "INFO" "Removing old CUDA Path if existed"
printc "YELLOW" "-> Removing old CUDA Path if existed..."
sleep 1
grep -l '# CUDA PATH' ~/.bashrc | xargs -I {} sed -i '/# CUDA PATH/d' {}
grep -l '/usr/local/cuda' ~/.bashrc | xargs -I {} sed -i '/usr\/local\/cuda/d' {}

log_message "INFO" "Switching CUDA Version to $version..."
printc "YELLOW" "-> Switching CUDA Version to $version..."
sleep 1
echo '# CUDA PATH' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
echo export PATH=/usr/local/$version/bin'${PATH:+:${PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"
echo export LD_LIBRARY_PATH=/usr/local/$version/lib64'\ {LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc || handle_error "Failed to add CUDA Path"

log_message "INFO" "Refreshing The Current Environment"
printc "YELLOW" "-> Refreshing The Current Environment..."
sleep 1
eval "$(cat ~/.bashrc | tail -n +10)" || handle_error "Failed to Apply CUDA Path"

log_message "INFO" "Checking the Switched Version"
printc "YELLOW" "-> Checking the Switched Version..."
sleep 1
nvcc --version || handle_error "Failed to check the Installed Version"
printc "GREEN" "-> CUDA Version Switched Successfully to $version..."
echo "Press [ENTER] To exit Script..."
read