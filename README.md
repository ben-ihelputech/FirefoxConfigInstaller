# Deploying a locked Firefox

How to deploy a copy of Firefox with a locked "about:config"

## Prerequisites

I recommend uninstalling or quarantining all other installations of Firefox if you are planning to use this guide for a kiosk or as the main browser in an enterprise environment. 

## Installing
### Debian/Ubuntu
Run the installer from the command line:
```
./debianInstaller.sh
```

### Mac
Run the installer from the command line:
```
./macInstaller.sh
```
#### Things to note:
Homebrew and wget are used in this script. If you are having issues, try to install them beforehand by going to the terminal and running:
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && brew update && brew install wget
```

The first option the installer will ask is where your ".cfg" file is located. This is your firefox.cfg file where all of the preferences are set.
You have two options when installing this:
1. Provide a web link where the script can download a hosted file. *The script currently uses wget as the main way of downloading files
2. Provide a path to a local .cfg file on your computer. The easiest way is to drap and drop the file into the terminal and it should interpret the path.

A few demo .cfg files are included for your connivence. Feel free to modify them to your needs!

## Error Codes
```
Error 201
```
Must specify whether the config files are web-hosted.

```
Error 202
```
The install folders where pre-existing and not overwritten. The current version of the script does not support keeping the pre-existing file/folders.

```
Error 203
```
Homebrew was not installed. Homebrew is currently necessary for this script.

## Acknowledgments
Credit to the following articles:
* (https://www.techrepublic.com/article/how-to-deploy-firefox-with-locked-aboutconfig-settings/)
* (https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig#w_setting-up-autoconfig)