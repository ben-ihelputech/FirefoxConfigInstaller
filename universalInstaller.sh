#!/bin/bash
#Universal Unix installer Version 0.1

#-----------------------------------------------
##Sections:
#1.) List of Variables
#2.) Gathering Arguments
#3.) Declaring Functions
#4.) User Input
#5.) OS dependent variables
#6.) Executing code
#7.) Script Complete
#-----------------------------------------------

#-----------------------------------------------
##List of all varibles
TEMPFOLDER="/tmp/FirefoxAuto"
CACHE="/tmp/FirefoxCache"
DEST=""
OVERWRITEDIR=""
OVERWRITECACHE=""
DMGPATH=""
DMGNAME="firefox.dmg"
TARPATH=""
TARNAME="firefox.tar.bz2"
SYSTEM="$(uname -s)"
VERSION="0.1"
SPACER="=================================="
WEBUSE=""
WEBPATH=""
LOCALCONFIGPATH=""
ALIASPATH=""
SKIPCONFIG=""
DOWNLOADMETHOD=""

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
#-----------------------------------------------


#-----------------------------------------------
##Gathering Arguments
# echo ""
# echo "$SPACER"
# echo "Welcome to Firefox Autoconfig Installer"
# echo "Version: $VERSION"
# echo "Detected shell os: $SYSTEM"
# echo "Number of arguments: $#"
# echo "$SPACER"
# echo ""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help )       #Help page
            less .help.txt
            exit 0
            ;;

        -a | --alias)
            echo "Option selected: $1"
            ALIASPATH="$2"
            echo "The alias will be placed at: $ALIASPATH"
            shift
            shift
            ;;

        --cache-dir )
            echo "Option selected: $1"
            CACHE="$2"
            echo "Cache directory set to: $CACHE"
            shift
            shift
            ;;

        --curl )
            echo "Option selected: $1"
            echo "cURL will be used as the default download option"
            DOWNLOADMETHOD="curl"
            shift
            ;;

        --firefox-dmg )
            echo "Option selected: $1"
            DMGPATH="$2"
            echo "Local path: $DMGPATH"
            shift
            shift
            ;;

        -i | --install-path )
            echo "Option selected: $1"
            DEST="$2"
            echo "Installation path: $DEST"
            shift
            shift
            ;;

        -l | --local )
            echo "Option selected: $1"
            WEBUSE="false"
            LOCALCONFIGPATH="$2"
            echo "Local path: $LOCALCONFIGPATH"
            shift
            shift
            ;;

        -o | --overwrite )
            echo "Option selected: $1"
            OVERWRITEDIR="true"
            OVERWRITECACHE="true"
            echo "All necessary directories and file will be overwritten."
            shift
            ;;

        -rf | --redownload-firefox )
            echo "Option selected: $1"
            echo "Firefox will be redownloaded"
            OVERWRITECACHE="true"
            shift
            ;;

        --tar-path )
            echo "Option selected: $1"
            TARPATH="$2"
            echo "Local path: $TARPATH"
            shift
            shift
            ;;

        -w | --web )        #Specify web config
            echo "Option selected: $1"
            WEBUSE="true"
            WEBPATH="$2"
            echo "Web Address: $WEBPATH"

            shift
            shift
            ;;

        --wget )
            echo "Option selected: $1"
            echo "wget will be used as the default download option"
            DOWNLOADMETHOD="wget"
            shift
            ;;

        *)                  #Catch invalid arguments and cancel the script.
            echo "Error! The selected option: '$1' is not valid.
Please see the help page for more details: $0 --help"
            exit 2
            ;;
    esac
done
#-----------------------------------------------


#-----------------------------------------------
##Declaring Functions
usePredownloadedFirefox () {
    #Test for DMG or tar
    if [[ -nz "$DMGPATH" ]]; then
        echo ""
        echo "$SPACER"
        echo "Copying user specified dmg..."
        echo "$SPACER"
        cp -a "$DMGPATH" "$CACHE"/"$DMGNAME"
    elif [[ -nz "$TARPATH" ]]; then
        echo ""
        echo "$SPACER"
        echo "Copying user specified tar..."
        echo "$SPACER"
        cp -a "$TARPATH" "$CACHE"/"$TARPATH"
    fi
}

#Reset Cache
resetCache () {
    echo ""
    echo "$SPACER"
    echo "Reseting the cache"
    echo "$SPACER"
    rm -Rf "$CACHE"
    mkdir "$CACHE"

    if [[ -z "$DMGPATH" ]] && [[ -z "$TARPATH" ]]; then
        #Test for wget and curl
        local CURLPRESENT="$(command -v curl >/dev/null 2>&1 || echo "missing")"
        local WGETPRESENT="$(command -v wget >/dev/null 2>&1 || echo "missing")"
        if [[ "$CURLPRESENT" == "missing" ]]; then
            CURLPRESENT="false"
        else
            CURLPRESENT="true"
        fi
        if [[ "$WGETPRESENT" == "missing" ]]; then
            WGETPRESENT="false"
        else
            WGETPRESENT="true"
        fi

        #Set download method
        if [[ -z "$DOWNLOADMETHOD" ]]; then
            if [[ "$CURLPRESENT" == "true" ]]; then
                DOWNLOADMETHOD="curl"
            elif [[ "$WGETPRESENT" == "true" ]]; then
                DOWNLOADMETHOD="wget"
            else
                echo "Error setting download method: wget or curl not installed"
                read -p "Would you like to exit the script or install wget or curl? wget/curl/exit: " DOWNLOADMETHOD
                case "$DOWNLOADMETHOD" in
                    [wW] | [wW][gG][eE][tT] )
                        apt-get install wget
                        DOWNLOADMETHOD="wget"
                        ;;
                    [cC] | [cC][uU][rR][lL] )
                        apt-get install curl
                        DOWNLOADMETHOD="curl"
                        ;;
                    *)
                        echo "Download method not selected. Exiting..."
                        exit 1
                esac
            fi
        fi

        #Download Firefox
        case "$SYSTEM" in
            Darwin )
                if [[ "$DOWNLOADMETHOD" == "curl" ]]; then
                    curl --location-trusted -o "$CACHE"/"$DMGNAME" "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US"
                elif [[ "$DOWNLOADMETHOD" == "wget" ]]; then
                    wget "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US" --trust-server-names -O "$CACHE"/"$DMGNAME"
                fi
                ;;
            Linux )
                if [[ "$DOWNLOADMETHOD" == "curl" ]]; then
                    curl --location-trusted -o "$CACHE"/"$TARNAME" "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
                elif [[ "$DOWNLOADMETHOD" == "wget" ]]; then
                    wget "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" --trust-server-names -O "$CACHE"/"$TARNAME"
                fi
                ;;
            *)
                echo "Error reseting cache"
                echo "Error 204; Operating system not supported: $SYSTEM"
                exit 2
                ;;
        esac
    else
        usePredownloadedFirefox
    fi
}

#Ask to reset cache
askReset () {
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
}

#Reset destination variable to default location
setDefaultDest () {
    case "$SYSTEM" in
        Darwin )
            # echo "I'm a Mac!"
            DEST="/Users/$(whoami)/.firefox/"
            ;;
        Linux )
            # echo "Linux Master Race!"
            DEST="/opt/firefox"
            ;;
        *)
            echo "Error trying to set default location."
            echo "Error 204; Operating system not supported: $SYSTEM"

            exit 2
            ;;
    esac
}


#-----------------------------------------------

#-----------------------------------------------
##User Input
#Set path of configuration file
if [[ -z "$WEBUSE" ]]; then         #Test to see if WEBUSE has var set, if not, set CONFIG PATH
    read -p "Are you using a web-hosted config file? Yes/No: " WEBUSE
    case "$WEBUSE" in
        [yY] | [yY][eE][sS] )
            #The user is using a web config
            read -p "Please enter the URL of your .cfg file: " WEBPATH
            WEBUSE="true"
            ;;
        [nN] | [nN][oO] )
            #The user is not using web config
            read -p "Please enter the local path of your .cfg file: " LOCALCONFIGPATH
            WEBUSE="false"
            ;;
        *)
            echo "Error 201: Must specify whether the config files are web-hosted.
            Please view the README file for more info"
            exit 2
            ;;
    esac
fi

#Test to see if path is empty
if [[ -z "$WEBPATH" ]] && [[ -z "$LOCALCONFIGPATH" ]]; then
    read -p "You have not specified a path to a config file. Continue anyway? Yes/[No]: " SKIPCONFIG
    case "$SKIPCONFIG" in
        [yY] | [yY][eE][sS] )
            echo "$SPACER"
            echo "⚠️ Warning: Specifying the config file may cause errors. Continuing anyway."
            echo "$SPACER"
            SKIPCONFIG="true"
            ;;
        [nN] | [nN][oO] )
            echo "Exiting the script..."
            exit 1
            ;;
        *)
            echo "Exiting the script..."
            exit 2
            ;;
    esac
fi

#Testing for cached Firefox
if [[ -z "$OVERWRITECACHE" ]]; then
    case "$SYSTEM" in
        Darwin )
            if [[ -e "$CACHE"/"$DMGNAME" ]]; then
                askReset    #Ask to reset cache (function)
            fi
            ;;
        Linux )
            if [[ -e "$CACHE"/"$TARNAME" ]]; then
                askReset    #Ask to reset cache (function)
            fi
            ;;
        *)
            echo "Error testing cache"
            echo "Error 204; Operating system not supported: $SYSTEM"

            exit 2
            ;;
    esac
fi
#Set Default Destination
if [[ -z "$DEST" ]]; then
    setDefaultDest
fi

#Testing for all other directories
if [[ -z "$OVERWRITEDIR" ]]; then
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
        # echo "No directories present"
        OVERWRITEDIR=false
    fi
fi
#-----------------------------------------------


#-----------------------------------------------
##OS dependent variables
if [[ -z "$ALIASPATH" ]]     #Set the alias
    then
        case "$SYSTEM" in
            Darwin )
                ALIASPATH="/Users/$(whoami)/Desktop/Firefox\ Profile.alias"
                ;;
            Linux )
                ALIASPATH="/usr/bin/firefox"
                ;;
            *)
                echo "Error 204; Operating system not supported: $SYSTEM"
                exit 2
                ;;
        esac
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
        rm "$ALIASPATH"
fi
echo "Making new folders..."
mkdir "$CACHE"
mkdir "$TEMPFOLDER"
mkdir "$DEST"

#Download Firefox
if [[ "$OVERWRITECACHE" == "true" ]]; then
    resetCache
elif [[ -nz "$DMGPATH" ]] || [[ -nz "$TARPATH" ]]; then
    usePredownloadedFirefox
fi

#Copy Firefox to temp folder
case "$SYSTEM" in
    Darwin )
        echo ""
        echo "$SPACER"
        echo "Copying Firefox..."
        echo "$SPACER"

        cp -a "$CACHE"/"$DMGNAME" "$TEMPFOLDER"
        hdiutil attach "$TEMPFOLDER"/"$DMGNAME"
        cp -a /Volumes/Firefox/Firefox.app "$TEMPFOLDER"
        sleep 2
        hdiutil detach /Volumes/Firefox -force
        ;;
    Linux )
        echo ""
        echo "$SPACER"
        echo "Copying Firefox..."
        echo "$SPACER"

        cp -a "$CACHE"/"$TARNAME" "$TEMPFOLDER"
        tar xvfj "$TEMPFOLDER"/"$TARNAME" -C "$TEMPFOLDER"
        ;;
esac

#Rename & copy .cfg file and copy autostart.js
echo ""
echo "$SPACER"
echo "Copying configuration..."
echo "$SPACER"

if [[ -z "$LOCALCONFIGPATH" ]]; then #Test to see if local config path has been set.
    echo "Local config path has not been set. Setting now..."
    LOCALCONFIGPATH="${0%/*}/firefox.cfg"
fi

if [[ "$WEBUSE" == true ]]; then #copies cfg to cache
    case "$SYSTEM" in
        Darwin )
            if [[ "$DOWNLOADMETHOD" == "curl" ]]; then
                curl --location-trusted -o "$CACHE"/firefox.cfg "$WEBPATH"
            elif [[ "$DOWNLOADMETHOD" == "wget" ]]; then
                wget "$WEBPATH" --trust-server-names -O "$CACHE"/firefox.cfg
            fi
            ;;
        Linux )
            if [[ "$DOWNLOADMETHOD" == "curl" ]]; then
                curl --location-trusted -o "$CACHE"/firefox.cfg "$WEBPATH"
            elif [[ "$DOWNLOADMETHOD" == "wget" ]]; then
                wget "$WEBPATH" --trust-server-names -O "$CACHE"/firefox.cfg
            fi
            ;;
    esac
else
    ls "$LOCALCONFIGPATH" >/dev/null 2>&1 || { echo >&2 "Local configuration not found. Aborting..."; exit 2; }
    cp "$LOCALCONFIGPATH" "$CACHE"/firefox.cfg
    cp autostart.js "$CACHE"/autostart.js
fi

case "$SYSTEM" in   #copy, install, link
    Darwin )
        cp autostart.js "$TEMPFOLDER"/Firefox.app/Contents/Resources/defaults/pref/
        cp "$CACHE"/firefox.cfg "$TEMPFOLDER"/Firefox.app/Contents/Resources/
        cp -a "$TEMPFOLDER"/Firefox.app "$DEST"
        ln -s "$DEST" "$ALIASPATH"
        ;;
    Linux )
        cp "$CACHE"/autostart.js "$TEMPFOLDER"/firefox/defaults/pref/
        cp "$CACHE"firefox.cfg "$TEMPFOLDER"/firefox/
        sudo mv "$TEMPFOLDER"/firefox "$DEST"
        sudo ln -s "$DEST"/firefox "$ALIASPATH"
        touch ~/.local/share/applications/firefox.desktop
        echo "$DESKTOP" >> ~/.local/share/applications/firefox.desktop
esac

#Cleaning up
echo "$SPACER"
echo "Cleaning up..."
echo "$SPACER"
rm -Rf "$TEMPFOLDER"
#-----------------------------------------------


#-----------------------------------------------
##Script Complete
echo ""
echo "$SPACER"
echo "👍 All done!"
echo "$SPACER"
#-----------------------------------------------
