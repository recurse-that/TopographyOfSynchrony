#!/bin/bash
echo "Go to https://www.mathworks.com/downloads/web_downloads login to mathworks and download the matlab_R2021b_glnxa64.zip file in the current directory"
echo "Is the zip file in this directory? [y,n]"
read uin
if [[ $uin == "Y" || $uin == "y" ]]; then
	# Make sure the zip file hasn't been unzipped
	echo "If you want to unzip the file manually or if you have already unzipped the file type n"
	echo "Do you want to unzip the file? [y,n]"
	read uin
elif [[ $uin == "N" || $uin == "n" ]]; then
	echo "Locate the zip file and move to this directory"
	echo "Type done when the zip file is in the current directory"
	read uin
	if [[$uin == "Done" || $uin == "done"]]; then
		echo "If you want to unzip the file manually or if you have already unzipped the file type n"
		echo "Do you want to unzip the file? [y,n]"
		read uin
	fi # end inner if
fi # end outer if / elif
# If they wanted to unzip the file
if [[ $uin == "Y" || $uin == "y" ]]; then
	unzip -X -K matlab_R2021b_glnxa64.zip -d matlab_2021b_installer
	# Confirm permissions to write to the install location
	chown -R $LOGNAME: /usr/local/MATLAB
	chmod o+rwx -R /usr/local/MATLAB
	chmod o+rwx matlab_2021b_installer
	cd matlab_2021b_installer
	ln -s /usr/local/MATLAB/bin/matlab /usr/local/bin/matlab
	# Install
	echo "Login then make sure to check the following toolboxes when prompted:"
	echo "Antenna Toolbox"
	echo "Image Processing Toolbox"
	echo "Mapping Toolbox"
	echo "Statistics and Machine Learning Toolbox"
	sh ./install
	alias matlab='/usr/local/MATLAB/R2021b/bin/matlab'
	rm matlab_R2021b_glnxa64.zip
fi # end if
