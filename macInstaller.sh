#!/bin/bash
#macOS Installer

echo "The macOS installer is still in progress...
Please checkback later"

#List of all varibles
# TEMPFOLDER="/tmp/lockedFirefox"
# OVERWRITE=""
# REMOVE=""
# FIRETAR="firefox.bz2"
# SPACER="==================="
# AUTOCONFIG=""
# FIREFOXCFG=""
# WHICH="which firefox"
#
# #Test for homebrew
# which -s brew
# if [[ $? != 0 ]] ; then
#     # Install Homebrew
#     #ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# else
#     brew update
# fi
#
# #Set config file names
# read -p "Specify the location of autoconfig.js (Enter for default)" AUTOCONFIG
# echo "autoconfig.js has been set as "$AUTOCONFIG""
# read -p "Specify the location of firefox.cfg (Enter for default)" FIREFOXCFG
# echo "firefox.cfg has been set as "$FIREFOXCFG""
# echo "$SPACER"
#
# #Remove firefox
#
# #Make temp folder
# if [ -d "$TEMPFOLDER" ]
# then
# 	# echo "Temp folder exists"
# 	read -p "The temp folder already exist. Do you want to overwrite it? y/(n): " OVERWRITE
# 	case "$OVERWRITE"  in
# 	[yY] | [yY][eE][sS])
# 		echo "Overwriting old folder..."
# 		rm -Rf "$TEMPFOLDER"
# 		mkdir "$TEMPFOLDER"
# 		;;
# 	[nN] | [nN][oO])
# 		echo "Stopping script..."
# 		exit 1
# 		;;
# 	*)
# 		echo "Stopping script..."
# 		exit 1
# 		;;
# 	esac
# else
# 	# echo "Temp folder does NOT exist"
# 	mkdir "$TEMPFOLDER"
# fi
# OVERWRITE=""
#
# #download firefox
#
# #Decompress Firefox
#
# #Configuring Firefox
# if [ -z "$AUTOCONFIG" ]
# 	echo "$SPACER"
# 	echo "The autoconfig.js file has not been set. Skipping..."
# 	echo "$SPACER"
# else
# 	echo "$SPACER"
# 	echo "Copying autoconfig.js..."
# 	echo "$SPACER"
# 	cp "$AUTOCONFIG" "$TEMPFOLDER"/firefox/defaults/pref/
# fi
# if [ -z "FIREFOXCFG" ]
# 	echo "$SPACER"
# 	echo "The firefox.cfg file has not been set. Skipping..."
# 	echo "$SPACER"
# else
# 	echo "$SPACER"
# 	echo "Copying autoconfig.js..."
# 	echo "$SPACER"
# 	cp "FIREFOXCFG" "$TEMPFOLDER"/firefox/
# fi
#
# #Copy to /opt and install
#
# #Cleaning up
#
# #Completed
# echo "$SPACER"
# echo "Firefox has been installed"
# echo "$SPACER"