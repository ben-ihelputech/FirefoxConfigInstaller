#!/bin/bash
#Debian/Ubuntu Installer
#List of all varibles
TEMPFOLDER="/tmp/lockedFirefox"
OVERWRITE=""
REMOVE=""
FIRETAR="firefox.bz2"
SPACER="==================="
AUTOSTART=""
CFG=""
WHICH="which firefox"

#Desktop Entry
DESKTOP="[Desktop Entry]
Version=1.1
Name=Firefox
GenericName=Firefox
Comment=Firefox
Exec=/usr/bin/firefox
Terminal=false
Icon=/opt/firefox/browser/chrome/icons/default/default48.png
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;"

#Autostart.js


#Set config file names
read -p "Specify the location of autostart.js (Enter for default)" AUTOSTART
echo "autostart.js has been set as "$AUTOSTART""
read -p "Specify the location of firefox.cfg (Enter for default)" CFG
echo "firefox.cfg has been set as "$CFG""
echo "$SPACER"

#Remove firefox
read -p "Do you want to remove Firefox? (y)/n/stop: " REMOVE
case "$REMOVE" in
[yY] | [yY][eE][sS])
	echo "Removing Firefox..."
	sleep 1
	sudo apt remove firefox
	sudo rm "$WHICH"
	if [ -e ~/.local/share/applications/firefox.desktop ]
	then
		rm ~/.local/share/applications/firefox.desktop
	fi
	;;
[nN] | [nN][oO])
	echo "WARNING: continuing without removing Firefox may cause problems"
	echo "Waiting 5 seconds..."
	sleep 5
	;;
[sS] | [sS][tT][oO][pP])
	echo "Stopping script"
	exit 1
	;;
*)
	echo "Removing Firefox..."
	sleep 1
	sudo apt remove firefox
	;;
esac

#Make temp folder
if [ -d "$TEMPFOLDER" ]
then
	# echo "Temp folder exists"
	read -p "The temp folder already exist. Do you want to overwrite it? y/(n): " OVERWRITE
	case "$OVERWRITE"  in
	[yY] | [yY][eE][sS])
		echo "Overwriting old folder..."
		rm -Rf "$TEMPFOLDER"
		mkdir "$TEMPFOLDER"
		;;
	[nN] | [nN][oO])
		echo "Stopping script..."
		exit 1
		;;
	*)
		echo "Stopping script..."
		exit 1
		;;
	esac
else
	# echo "Temp folder does NOT exist"
	mkdir "$TEMPFOLDER"
fi
OVERWRITE=""

#download firefox
echo "$SPACER"
echo "Downloading Firefox..."
echo "$SPACER"
wget "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US" --trust-server-names -O "$TEMPFOLDER"/"$FIRETAR"

#Decompress Firefox
echo "$SPACER"
echo "Decompressing download..."
echo "$SPACER"
tar xvfj "$TEMPFOLDER"/"$FIRETAR" -C "$TEMPFOLDER"

#Configuring Firefox
if [ -z "$AUTOSTART" ]
then
	echo "$SPACER"
	echo "The autostart.js file has not been set. Setting now..."
	echo "$SPACER"
	AUTOSTART="autostart.js"
fi

echo "$SPACER"
echo "Copying autostart.js..."
echo "$SPACER"
cp "$AUTOSTART" "$TEMPFOLDER"/firefox/defaults/pref/

if [ -z "FIREFOXCFG" ]
then
	echo "$SPACER"
	echo "The firefox.cfg file has not been set. Setting now..."
	echo "$SPACER"
	FIREFOXCFG="firefox.cfg"
fi

echo "$SPACER"
echo "Copying firefox.cfg..."
echo "$SPACER"
cp "$FIREFOXCFG" "$TEMPFOLDER"/firefox/


#Copy to /opt and install
if [ -d /opt/firefox ]
then
	read -p "A copy of Firefox already exists in your /opt folder. Do you want to overwrite it? y/(n):" OVERWRITE
	case "$OVERWRITE"  in
	[yY] | [yY][eE][sS])
		echo "Overwriting old folder..."
		sudo rm -Rf /opt/firefox
		;;
	[nN] | [nN][oO])
		echo "$SPACER"
		echo "Stopping script..."
		echo "$SPACER"
		exit 1
		;;
	*)
		echo "$SPACER"
		echo "Stopping script..."
		echo "$SPACER"
		exit 1
		;;
	esac
fi
	echo "$SPACER"
	echo "Copying to /opt folder and making link..."
	echo "$SPACER"
	sudo mv "$TEMPFOLDER"/firefox /opt
	sudo ln -s /opt/firefox/firefox /usr/bin/firefox
	touch ~/.local/share/applications/firefox.desktop
	echo "$DESKTOP" >> ~/.local/share/applications/firefox.desktop


#Cleaning up
echo "$SPACER"
echo "Cleaning up..."
echo "$SPACER"
rm -Rf "$TEMPFOLDER"

#Completed
echo "$SPACER"
echo "Firefox has been installed"
echo "$SPACER"
