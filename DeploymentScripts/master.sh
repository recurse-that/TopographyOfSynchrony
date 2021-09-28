#!/bin/bash

# Confirm proper R and R-Studio installation
echo "Do you have R and R Studio installed on your machine? [y,n]"
read uin
# If the user has installed R and R studio
if [[ $uin == "N" || $uin == "n" ]]; then
        cd installation
        chmod +x installR.sh # Give installR.sh executive permissions
        sh ./installR.sh # Run installR
        cd ../dependencies
        chmod +x R_dependencies.sh # Give R_dependencies executive permissions
        sh ./R_dependencies.sh # install R_dependencies
        cd -
fi
# Confirm dependencies on R and linux packages
echo "Do you have all of the necessary dependencies installed for R"
read uin
# If the user has R and R studio but doesn't have the necessary dependencies
if [[ $uin == "N" || $uin == "n" ]]; then
        cd dependencies
        chmod +x R_dependencies.sh # Give R_dependencies executive permissions
        sh ./R_dependencies.sh # install R_dependencies
fi

#Confirm matlab has been installed
echo "Do you have Matlab installed on your machine? [y,n]"
read uin
if [[ $uin == "N" || $uin == "n" ]]; then
        chmod +x installMatlab.sh #Give installMatlab executive permissions
        sh ./installMatlab.sh # run installMatlab
fi
#Confirm toolboxes are installed
echo "Did you install the matlab toolboxes specified in the readme? [y,n]"
read uin
if [[ $uin == "N" || $uin == "n" ]]; then
	echo "Login then make sure to check the following toolboxes when prompted:"
	echo "Mapping Toolbox"
	echo "Antennae Toolbox"
	echo "Statistics and Machine Learning Toolbox"
	echo "Image Processing Toolbox"
	cd matlab_2021b_installer
	sh ./install
fi

#Confirm modis data dependencies
echo "Have you downloaded the data specified in the dependencies section of the readme? [y,n]"
read uin
if [[ $uin == "N" || $uin == "n" ]]; then
	#install curl
	apt install curl
	cd -/Data
	curl https://kars.ku.edu/media/downloads/Kastens/reuman/ancillary_mat.7z
	curl https://kars.ku.edu/media/downloads/Kastens/reuman/ancillary_tif.7z
	curl https://kars.ku.edu/media/downloads/Kastens/reuman/mxvi_mat.7z
	curl https://kars.ku.edu/media/downloads/Kastens/reuman/mxvi_tif.7z
	curl wget https://kars.ku.edu/media/downloads/Kastens/reuman/modis_qkm_water_mask_v2.mat
	cd -/deploymentScripts
fi
echo "Did curl download the data [y,n]"
read uin
if [[ $uin == "N" || $uin == "n" ]]; then
	echo "Click each of the following links and install in the Data Folder"
	echo "https://kars.ku.edu/media/downloads/Kastens/reuman/ancillary_mat.7z"
	echo "https://kars.ku.edu/media/downloads/Kastens/reuman/ancillary_tif.7z"
	echo "https://kars.ku.edu/media/downloads/Kastens/reuman/mxvi_mat.7z"
	echo "https://kars.ku.edu/media/downloads/Kastens/reuman/mxvi_tif.7z"
	echo "wget https://kars.ku.edu/media/downloads/Kastens/reuman/modis_qkm_water_mask_v2.mat"
fi
echo "Type done when you have downloaded the data"
read uin
if [[ $uin == "Done" || $uin == "done"]]; then
  echo "If you want to unzip the 7z files manually or if you have already unzipped the file type n"
  echo "Do you want to unzip the file? [y,n]"
  read uin
  # If the user wants to unzip the 7 zip files
  if [[ $uin == "Y" || $uin == "y" ]]; then
    # install package to unzip the MODIS data
    apt-get -y install p7zip-full
    cd -/Data
    # unzip the ancillary_mat.7z archive
    mkdir ancillary_mat
    mv ancillary_mat.7z ancillary_mat
    # unzip the watermask
    mv modis_qkm_water_mask_v2.mat ancillary_mat
    cd ancillary_mat
    7za e ancillary_mat.7z
    rm ancillary_mat.7z
    cd -
    # unzip the mxvi_mat.7z archive
    mkdir mxvi_mat
    mv mxvi_mat.7z mxvi_mat
    cd mxvi_mat
    7za e mxvi_mat.7z
    rm mxvi_mat.7z
    cd -
  fi # end inner for
fi # end outer if




#TODO: Confirm kml data dependencies
