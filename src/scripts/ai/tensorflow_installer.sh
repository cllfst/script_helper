#!/usr/bin/env bash -i

source $(pwd)/src/utils.sh
LOG_FILE=$(pwd)/src/logfile.log



trap 'handle_error "An unexpected error occurred."' ERR
clear
echo "Continue script execution in Tensorflow Installation at $(date)" >> "$LOG_FILE"

dryRunCheck(){

	log_message "INFO" "Performing Dry Run for TensorFlow Installation"
	printc "CYAN" "-> Performing Dry Run for TensorFlow Installation..."
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
		printc "GREEN" "base is the default conda env in this current shell session"
	else
		printc "RED" "base is NOT the default conda env in this current shell session"
    fi

	log_message "INFO" "2. Checking for CUDA Toolkit and NVIDIA Drivers"
	printc "YELLOW" "2. Checking for CUDA Toolkit and NVIDIA Drivers..."
	sleep 1
	while true; do
    	echo -n "-> Do you plan to install TensorFlow with CUDA Support? (Y/n): "
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


installTensorFlow(){
	while true; do
	
		printc "YELLOW" "What Compute Platform do you want to use ?"
		echo "1. CPU"
		echo "2. CUDA"
		echo -n "Your Compute Platform : "
		read option
		case $option in
		1)
		    log_message "INFO" "User chose to Installing Tensorflow with CPU Support"
			printc "YELLOW" "-> Installing Tensorflow with CPU Support..."
		    sleep 1
		    python3 -m pip install tensorflow || handle_error "Failed to Install Tensorflow with CPU Support"
		    
			printc "CYAN" "-> Verifying TensorFlow With CPU Support Installation"
			printc "YELLOW" "-> By Executing python -c 'import tensorflow as tf; print(tf.random.normal([5, 5]))' "
			echo -e "-> If a result is returned, then tensorflow is ${GREEN}installed${RESET}"
			echo "Press [ENTER] to continue..."
			read
			sleep 1
			python -c "import tensorflow as tf; print(tf.random.normal([5, 5]))" || handle_error "Failed to check if tensorflow is installed"
			echo -n "Press [ENTER] To Continue..."
			read
				
		    return
		    ;;
		2)
		    echo "# For Tensorflow with CUDA Support to work,"
	   	    echo "# Make sure that you have : "
			printc "YELLOW" "# 1. NVIDIA Driver Installed on your Machine"
			printc "YELLOW" "# 2. NVIDIA CUDA Toolkit Installed on your Machine"
	   	    echo "Press [ENTER] to continue..."
	   	    read
	   	    
		    log_message "INFO" "User chose to Installing Tensorflow with CUDA Support"
		    log_message "INFO" "Installing cuDNN Package"
			printc "YELLOW" "-> Installing cuDNN Package..."
		    sleep 1
		    conda install -c conda-forge cudnn || handle_error "Failed to Install cuDNN Package"
		    
			printc "YELLOW" "-> Installing Tensorflow with CUDA Support..."
		    sleep 1
		    python3 -m pip install tensorflow[and-cuda] || handle_error "Failed to Install Tensorflow with CUDA Support"
		    
			printc "CYAN" "-> Verifying TensorFlow Installation with CUDA Support"
			printc "YELLOW" "-> By Executing python -c 'import tensorflow as tf; print(tf.test.is_built_with_cuda())' "
			echo -e "-> If Returned True, then Tensorflow is ${GREEN}installed with CUDA Support${RESET}"
			echo -n "Press [ENTER] to continue..."
			read
			sleep 1
			python -c "import tensorflow as tf; print(tf.test.is_built_with_cuda())" || handle_error "Failed to check if Tensorflow with CUDA Support is installed"
			echo -n "Press [ENTER] to continue..."
			read

		    return
		    ;;
		*)
		    log_message "WARN" "User chose a wrong option : ${r}"
		    invalidOption
		    ;;
		esac
		
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
        log_message "INFO" "User chose option ${option}"

		case $option in

		1)
			log_message "INFO" "Creating a New working Environment"
			printc "YELLOW" "-> Creating a New working Environment..."
			sleep 1
			echo -n "Type your environment Name : "
			read new_env
			conda create --name $new_env python=3.10 || handle_error "Failed to create ${new_env} environment"

			log_message "INFO" "Activating The Working Environment : ${new_env}"
			printc "YELLOW" "-> Activating The Working Environment : ${new_env}..."
			sleep 1
			source activate base || handle_error "Failed to Activate ${new_env} Environment"
			conda activate $new_env || handle_error "Failed to Activate ${new_env} Environment"

			log_message "INFO" "Configuring System Paths for CONDA Environment"
			printc "YELLOW" "-> Configuring System Paths for CONDA Environment..."
			sleep 1
			mkdir -p $CONDA_PREFIX/etc/conda/activate.d || handle_error "Failed to Configure System Paths for CONDA Environment"
			echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh || handle_error "Failed to Configure System Paths for CONDA Environment"
            echo "To Activate This Environment , Execute the Following :"
            printc "GREEN" "conda activate ${new_env}"
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
            printc "YELLOW" "-> Checking The Existence of ${your_env}..."
            sleep 1

            if conda info --envs | grep -q $your_env; then

                printc "GREEN" "${your_env} Exists..."
                sleep 1
				log_message "INFO" "Activating The Working Environment : ${your_env}"
				printc "YELLOW" "-> Activating The Working Environment : ${your_env}..."
				sleep 1
				source activate base || handle_error "Failed to Activate ${your_env }Environment"
				conda activate $your_env || handle_error "Failed to Activate ${your_env} Environment"

				log_message "INFO" "Configuring System Paths for CONDA Environment"
				printc "YELLOW" "-> Configuring System Paths for CONDA Environment..."
				sleep 1
				mkdir -p $CONDA_PREFIX/etc/conda/activate.d || handle_error "Failed to Configure System Paths for CONDA Environment"
				echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/' > $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh || handle_error "Failed to Configure System Paths for CONDA Environment"
            	echo "To Activate This Environment , Execute the Following :"
            	printc "GREEN" "conda activate ${your_env}"
            	echo -n "Press [ENTER] To Continue Installation..."
            	read
            	break

            else

                printc "RED" "${your_env} Does NOT Exists !"
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

echo "# Before Proceeding to the installation of Tensorflow"
echo "# Make sure that : "
printc "YELLOW" "-> 1. Conda is Installed on your machine"
printc "YELLOW" "-> 2. The base conda environment of current shell session is (base)"
echo "PRESS [ENTER] to Continue..."
read

dryRunCheck

printc "YELLOW" "-> Checking for Internet Connection..."
sleep 1

if check_internet; then

	log_message "INFO" "Internet Connection Detected. Proceeding with Tensorflow Installation"
	printc "GREEN" "-> Internet Connection Detected. Proceeding with Tensorflow Installation..."
	sleep 1

	createEnvironment

	log_message "INFO" "Installing Tensorflow"
	installTensorFlow

	echo "Tensorflow Installation Completed Successfully at $(date)" >> "$LOG_FILE"
	printc "GREEN" "Tensorflow Installation Completed Successfully..."
	echo -n "PRESS [ENTER] to exit Script..."
	read

else

    handle_error "No Internet Connection Available, Exiting..."

fi
