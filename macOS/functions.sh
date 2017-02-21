#!/bin/bash

function checkIfAppInstalled {
  files=$(ls /Applications | grep "$1.app")
  if [[ $files ]]; then
      return 2
  else
    return 1
  fi
}

function installHomebrew {
  # Check if Homebrew is already installed
  brew -v > /dev/null 2>&1
  returnValue=$?
  if [[ "$returnValue" -ne "0" ]]
  then
      echo "Installing Homebrew..."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
      echo "Homebrew is already installed!"
      brew update && brew doctor && brew doctor
  fi

  # Install Homebrew basic applications
  brew install bash-completion

  # Adds cask repo to the list of formulae
  brew tap caskroom/cask

  brew install cask
  # brew install mas
}

function installOptionaCasklApp {
  read -p "Install \"$1\"? (y/n) " -n 1 choice
  echo 
  case "$choice" in 
    y|Y ) 
      brew cask install $1
      ;;
    n|N )
      # Do nothing
      ;;
    * ) echo "invalid option";;
  esac
}

function installZipApp {
  APP_NAME=$1
  ZIP_URL=$2
  checkIfAppInstalled $APP_NAME

  returnValue=$?
  case $returnValue in
    1*)
      curl -fsSL -o $TEMP_FOLDER$APP_NAME.zip $ZIP_URL
      unzip -d $TEMP_FOLDER $TEMP_FOLDER$APP_NAME.zip > /dev/null
      mv $TEMP_FOLDER$APP_NAME.app /Applications/$APP_NAME.app

      # Remove temp files
      rm -r $TEMP_FOLDER"__MACOSX" 2> /dev/null
      rm $TEMP_FOLDER$APP_NAME.zip

      # Open the App
      open -a $APP_NAME 
      ;;
    2*)
      echo "$APP_NAME is already installed!"
      ;;
  esac
}

function installJDKEnv {
  read -p "Install JDK environment? (y/n) " -n 1 choice
  echo 
  case "$choice" in 
    y|Y ) 
      brew cask install java
      brew install maven
      ;;
    n|N )
      # Do nothing
      ;;
    * ) echo "invalid option";;
  esac
}

function installNodeJSEnv {
  read -p "Install Node.js environment? (y/n) " -n 1 choice
  echo 
  case "$choice" in 
    y|Y )
      brew install node

      username=$(whoami)
      primary_group=$(id -g -n $username)
      echo "Asking for permission to change the \"/usr/local\" owner to actual user."
      sudo chown $username:$primary_group /usr/local

      # Use N to manage NodeJS versions: https://github.com/tj/n
      npm install -g n
      n latest

      # Install usefull packages
      npm install -g npm-check-updates
      npm install -g eslint-cli
      ;;
    n|N )
      # Do nothing
      ;;
    * ) echo "invalid option";;
  esac
}

function installApplications {
  # Install applications and utils
  installHomebrew

  installJDKEnv
  installNodeJSEnv

  # installZipApp "BetterTouchTool" "https://www.boastr.net/releases/BetterTouchTool.zip"
  # installZipApp "SourceTree" "https://downloads.atlassian.com/software/sourcetree/SourceTree_2.4.1a.zip"

  installOptionaCasklApp "visualvm"
  installOptionaCasklApp "google-chrome"
  installOptionaCasklApp "sourcetree"
  installOptionaCasklApp "visual-studio-code"
  installOptionaCasklApp "intellij-idea-ce"
  # installOptionaCasklApp "intellij-idea"
  installOptionaCasklApp "bettertouchtool"
  installOptionaCasklApp "docker"
  installOptionaCasklApp "firefox"
  installOptionaCasklApp "opera"
  installOptionaCasklApp "meo-music"
  installOptionaCasklApp "meocloud"
  installOptionaCasklApp "dropbox"
  installOptionaCasklApp "onedrive"
  installOptionaCasklApp "franz"
  installOptionaCasklApp "libreoffice"
  installOptionaCasklApp "gimp"
  installOptionaCasklApp "spotify"
  installOptionaCasklApp "evernote"
}

function cleanUpInstallationCaches {
  brew cleanup --force -s && rm -rf $(brew --cache)
}