#!/bin/bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log

trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Pytorch Installation at $(date)" >> "$LOG_FILE"

testCuda(){

    log_message "INFO" "Checking if Pytorch with CUDA Support is working"
    printc "YELLOW" "-> Checking if Pytorch with CUDA Support is working"
    printc "YELLOW" "-> By Executing python3 -c 'import torch; print(torch.cuda.get_device_name(0))'..."
    sleep 1
	python3 -c 'import torch; print(torch.cuda.get_device_name(0))' || handle_error "Failed to Check if Pytorch with CUDA Support is working"

    printc "GREEN" "-> Pytorch with CUDA Support is Installed..."
    sleep 1

}

dryRunCheck(){

	log_message "INFO" "Performing Dry Run for Pytorch Installation"
    printc "CYAN" "-> Performing Dry Run for Pytorch Installation..."
	sleep 1

	log_message "INFO" "1. Checking for Conda Installation"
    printc "YELLOW" "1. Checking for Conda Installation..."
	sleep 1
    if ! command -v conda &> /dev/null; then
        printc "RED" "ERROR: Conda is not installed. Please install Conda before proceeding..."
		read
        exit
    fi
    printc "GREEN" "-> Conda is installed."

	log_message "INFO" "1.1. Checking for active CONDA environment"
    printc "YELLOW" "1.1. Checking for active CONDA environment..."
	sleep 1
	local condaEnv=$CONDA_DEFAULT_ENV
	if [[ "$condaEnv" == "base" ]]; then
        printc "GREEN" "-> base is the default conda env in this current shell session"
	else
        printc "RED" "-> base is NOT the default conda env in this current shell session"
    fi

	log_message "INFO" "2. Checking for CUDA Toolkit and NVIDIA Drivers"
    printc "YELLOW" "2. Checking for CUDA Toolkit and NVIDIA Drivers..."
	sleep 1
	while true; do
    	echo -n -e "-> Do you plan to install Pytorch with CUDA Support? ${RED}[REQUIRES NVIDIA GPU]${RESET} (Y/n): "
    	read use_cuda
    	if [[ "$use_cuda" == "Y" || "$use_cuda" == "y" || "$use_cuda" == "" ]]; then

			log_message "INFO" "2.1. Checking for NVIDIA Drivers"
            printc "YELLOW" "2.1. Checking for NVIDIA Drivers..."
			sleep 1
    	    if ! command -v nvidia-smi &> /dev/null; then
                printc "RED" "ERROR: NVIDIA Driver is not installed."
    	    else
                printc "GREEN" "-> NVIDIA Driver is installed."
    	    fi

			log_message "INFO" "2.2. Checking for CUDA Toolkit"
            printc "YELLOW" "2.2. Checking for CUDA Toolkit..."
    	    sleep 1
    	    if ! nvcc --version &> /dev/null; then
                printc "RED" "ERROR: CUDA Toolkit is not installed."
    	    else
                printc "GREEN" "-> CUDA Toolkit is installed."
    	    fi

			break
		
		elif [[ "$use_cuda" == "n" || "$use_cuda" == "N" ]]; then
			break
		else
			invalidOption
    	fi
	done    
    echo -e "${GREEN}Dry Run Complete${RESET}. If no errors are reported, you can proceed with the installation."
	echo "Press [ENTER] to Install..."
	read
}

installPytorch(){
    while true; do

        log_message "INFO" "Choosing the compute platform"
        printc "CYAN" "-> Choose Your Compute Platform :"
        echo "1. CPU"
        echo -e "2. CUDA ${RED}[Requires NVIDIA GPU]${RESET}"
        echo -n "Your Option : "
        read option

        if [[ "$option" == "1" ]]; then

            log_message "INFO" "User chose to Install PyTorch with CPU Support"
            printc "YELLOW" "-> Installing PyTorch with CPU Support..."
            sleep 1
            conda install pytorch torchvision torchaudio cpuonly -c pytorch || handle_error "Failed to Install PyTorch with CPU Support"
            printc "GREEN" "-> Pytorch with CPU Support installed Successfully"
            return

        elif [[ "$option" == "2" ]]; then
            
            declare -A cudaOptions=(
                ["12.4"]=1
                ["12.1"]=1
                ["11.8"]=1
            )

            log_message "INFO" "User chose to Install Pytorch with CUDA Support"
            printc "YELLOW" "NOTE : Make sure you have NVIDIA Driver and NVIDIA CUDA Toolkit Installed !"
            printc "CYAN" "-> Choose the Compute Platform CUDA version :"
            echo "12.4"
            echo "12.1"
            echo "11.8"
            echo -n "Type Your CUDA Version To Install : "
            read co

            if [[ -v cudaOptions["$co"] ]]; then

                log_message "INFO" "User chose CUDA $co Support"
                printc "YELLOW" "-> Installing Pytorch with CUDA $co Support..."
                sleep 1
                conda install pytorch torchvision torchaudio pytorch-cuda=$co -c pytorch -c nvidia || handle_error "Failed to Installing PyTorch with CUDA $co Support"
                log_message "INFO" "Testing CUDA Support in Pytorch"
                testCuda
                return

            else

                log_message "WARN" "User chose a wrong option : $co"
                invalidOption

            fi

        else
            invalidOption
        fi

    done
    
}

createEnvironment(){

    while true; do

        log_message "INFO" "Choose your Environment Option"
        printc "CYAN" "Choose your Environment Option :"
        echo "1. Create a new Environment"
        echo "2. Choose an existing Environment"
        echo -n "Your Option : "
        read option
        log_message "INFO" "User chose option $option"

        case $option in

        1)
            log_message "INFO" "User chose to Create a New Working Environment"
            log_message "INFO" "Creating a New Working Environment"
            printc "YELLOW" "-> Creating a New Working Environment..."
            sleep 1
            echo -n "Type Your Environment Name : "
            read new_env
            conda create --name $new_env || handle_error "Failed to create $new_env environment"

            log_message "INFO" "Activating The Working Environment : $new_env"
            printc "YELLOW" "-> Activating The Working Environment : $new_env..."
            sleep 1
            source activate base || handle_error "Failed to Activate $new_env Environment"
            conda activate $new_env || handle_error "Failed to Activate $new_env Environment"
            echo "To Activate This Environment , Execute the Following :"
            printc "GREEN" "conda activate $new_env"
            echo -n "Press [ENTER] To Continue Installation..."
            read
            break
            ;;

        2)
            log_message "INFO" "Choosing an Existing Conda Environment"
            printc "YELLOW" "-> Choosing an Existing Conda Environment..."
            sleep 1

            echo -n "Type Your Existing Conda Environment : "
            read your_env
            printc "YELLOW" "-> Checking The Existence of $your_env..."
            sleep 1

            if conda info --envs | grep -q $your_env; then

                printc "GREEN" "$your_env Exists..."
                sleep 1
                log_message "INFO" "Activating The Working Environment : $your_env"
                printc "YELLOW" "-> Activating The Working Environment : $your_env..."
                sleep 1
                source activate base || handle_error "Failed to Activate $your_env Environment"
                conda activate $your_env || handle_error "Failed to Activate $your_env Environment"
                echo "To Activate This Environment , Execute the Following :"
                printc "GREEN" "conda activate $your_env"
                echo -n "Press [ENTER] To Continue Installation..."
                read
                break

            else

                printc "RED" "$your_env Does NOT Exists !"
                echo -n "Press [ENTER] To Try Again..."
                read

            fi
            ;;
        *)
            invalidOption
            clear
            ;;
        esac

    done

}

echo "# Before Proceeding to the installation of Pytorch"
echo "# Make sure that : "
printc "YELLOW" "-> 1. Conda is Installed on your machine$"
printc "YELLOW" "-> 2. The base conda environment of current shell session is (base)"
echo -n "Press [ENTER] to Continue..."
read

dryRunCheck

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Pytorch Installation"
    printc "GREEN" "-> Internet Connection Detected. Proceeding with Pytorch Installation..."
    sleep 1

    createEnvironment

    log_message "INFO" "Installing Pytorch"
    printc "YELLOW" "-> Installing Pytorch..."
    sleep 1
    installPytorch

    log_message "INFO" "Verifying the Pytorch installed Version"
    printc "YELLOW" "-> Verifying the installed Pytorch Version..."
    printc "YELLOW" "-> By Executing python3 -c 'import torch; print(torch.__version__)'"
    sleep 1
    python3 -c 'import torch; print(torch.__version__)' || handle_error "Failed to Print Pytorch version"

    echo "Pytorch Script Execution Completed Successfully at $(date)" >> "$LOG_FILE"
    printc "GREEN" "Pytorch Script Execution Completed Successfully..."
    echo "PRESS [ENTER] to exit..."
    read

else

    handle_error "No Internet Connection Available, Exiting..."

fi

