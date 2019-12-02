#!/bin/bash
#macOS Installer Version 1.1

#-----------------------------------------------
##Sections:
#1.) List of Variables
#2.) User Input
#3.) Executing code
#4.) Script Complete
#-----------------------------------------------

#-----------------------------------------------
##List of all varibles
TEMPFOLDER="/tmp/lockedFirefox"
CACHE="/tmp/FirefoxCache"
DEST="/Users/$(whoami)/.firefox/"
OVERWRITEDIR=""
OVERWRITECACHE=""
DMG="firefox.dmg"
DMGPRESENT=""
BREWINSTALLED=""
WEBCONFIG=""
WEBCONFIGPATH=""
LOCALCONFIGPATH=""
RESOURCES="Firefox.app/Contents/Resources"
#-----------------------------------------------

#-----------------------------------------------
##User Input

#Set path of configuration file
read -p "Are you using a web-hosted config file? Yes/No: " WEBCONFIG
	case "$WEBCONFIG" in
		[yY] | [yY][eE][sS] )
			#The user is using a web config
			WEBCONFIG="true"
			;;
		[nN] | [nN][oO] )
			#The user is not using web config
			OVERWRITECACHE="false"
			;;
		*)
			echo "Error 201: Must specify whether the config files are web-hosted.
			Please view the README file for more info"
			exit 201
			;;
	esac
if [[ "$WEBCONFIG" == "true" ]]; then
	# echo "Using WEBCONFIG"
	read -p "Please enter the URL of your .cfg file: " WEBCONFIGPATH
	# echo "$WEBCONFIGPATH"
else
	read -p "Please enter the local path of your .cfg file: " LOCALCONFIGPATH
	# echo "$LOCALCONFIGPATH"
fi

#Testing for cached Firefox DMG
if [ -e "$CACHE"/"$DMG" ]
then
	#echo "Firefox is cached"
	read -p "A version of Firefox is cached. Do you want to redownload it? Yes/(N)o: " OVERWRITECACHE
	case "$OVERWRITECACHE" in
		[yY] | [yY][eE][sS] )
			echo "A new version of Firefox will be downloaded"
			OVERWRITECACHE=true
			;;
		[nN] | [nN][oO] )
			echo "The current version will be used."
			OVERWRITECACHE=false
			;;
		*)
			echo "The current version will be used."
			OVERWRITECACHE=false
			;;
	esac	
else
	echo "Firefox is not cached. A new version will be downloaded"
	OVERWRITECACHE=true
fi

#Testing for all other directories
if [[ -d "$DEST" ]] || [[ -d "$TEMPFOLDER" ]]; then
	read -p "One or more folders already exists. Do you want to overwrite them? (Y)es/No: " OVERWRITEDIR
	case "$OVERWRITEDIR" in
		[yY] | [yY][eE][sS] )
			echo "The folders will be overwritten."
			OVERWRITEDIR=true
			;;
		[nN] | [nN][oO] )
			echo "Error 202: Folders not overwritten.
			Please view the README file for more info"
			exit 202
			# echo "The current version will be used."
			# OVERWRITECACHE=false
			;;
		*)
			echo "The folders will be overwritten."
			OVERWRITEDIR=true
			;;
	esac
else
	echo "No directories present"
	OVERWRITEDIR=false
fi

#Test for Homebrew
which -s brew
if [[ $? != 0 ]]; 
	then
		read -p "Homebrew is neccesarry for this script. Do you want to install it? (Y)es/No: " BREWINSTALLED
		case "$BREWINSTALLED" in
			[yY] | [yY][eE][sS] )
				echo "Homebrew will be installed."
				BREWINSTALLED=false
				;;
			[nN] | [nN][oO] )
				echo "Error 203: Homebrew was not installed.
				Please view the README file for more info"
				exit 203
				
				;;
			*)
				echo "Homebrew will be installed."
				BREWINSTALLED=false
				;;
		esac
	else
		echo "Homebrew is installed"
		BREWINSTALLED=true
fi

#-----------------------------------------------

#-----------------------------------------------
##Executing code

#Reset and make directories
if [[ "$OVERWRITEDIR" == "true" ]]; 
	then
		echo "Removing old files and folders..."
		rm -Rf "$TEMPFOLDER"
		rm -Rf "$DEST"
		rm /Users/$(whoami)/Desktop/Firefox\ Profile.alias
fi
echo "Making new folders..."
mkdir "$CACHE"
mkdir "$TEMPFOLDER"
mkdir "$DEST"


#Install Homebrew & wget
if [[ "$BREWINSTALLED" == "false" ]] ; then
	echo "Installing Homebrew..."
    # Install Homebrew
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install wget
else
    brew install wget
    echo "Installing wget..."
fi

#download firefox
if [[ "$OVERWRITECACHE" == "true" ]]; 
	then
		wget "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US" --trust-server-names -O "$CACHE"/"$DMG"	
fi

#Copy firefox.dmg to tempfolder, mount the dmg, and copy dmg to temp folder
echo "Copying Firefox..."
cp -a "$CACHE"/"$DMG" "$TEMPFOLDER"
hdiutil attach "$TEMPFOLDER"/"$DMG"
cp -a /Volumes/Firefox/Firefox.app "$TEMPFOLDER"
sleep 2
hdiutil detach /Volumes/Firefox -force


#Rename & copy .cfg file and copy autostart.js
echo "Copying configuration..."
if [[ "$WEBCONFIG" == "true" ]]; 
	then
		wget "$WEBCONFIGPATH" --trust-server-names -O "$TEMPFOLDER"/"$RESOURCES"/firefox.cfg
		cp autostart.js "$TEMPFOLDER"/"$RESOURCES"/defaults/pref/
	else
		cp "$LOCALCONFIGPATH" "$TEMPFOLDER"/"$RESOURCES"/firefox.cfg
		cp autostart.js "$TEMPFOLDER"/"$RESOURCES"/defaults/pref/
fi

#Move Firefox to final destination and make alias
echo "Making desktop shortcut..."
cp -a "$TEMPFOLDER"/Firefox.app "$DEST"
ln -s "$DEST"/Firefox.app /Users/$(whoami)/Desktop/Firefox\ Profile.alias

#Clean up
echo "Cleaning up..."
rm -Rf "$TEMPFOLDER"

#-----------------------------------------------

#-----------------------------------------------
##Script Complete
echo "=============================
👍 Finished! Firefox can now be opened at:
'/Users/$(whoami)/Desktop/Firefox\ Profile.alias'
============================="
