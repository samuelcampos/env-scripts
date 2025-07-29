#!/bin/bash

function checkIfAppInstalled () {
  files=$(ls /Applications | grep "$1.app")
  if [[ $files ]]; then
      return 2
  else
    return 1
  fi
}

function installHomebrew () {
  # Check if Homebrew is already installed
  brew -v > /dev/null 2>&1
  returnValue=$?
  if [[ "$returnValue" -ne "0" ]]
  then
      echo "Installing Homebrew..."
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
      echo "Homebrew is already installed!"
      brew update && brew doctor && brew upgrade
  fi

  # Install Homebrew basic applications
  brew install bash-completion

  # Adds cask repo to the list of formulae
  brew tap caskroom/cask

  brew install cask
  brew install mas
}

function installCaskApp () {
  if yesNoQuestion "Install \"$1\"?"; then
    brew cask install $1
    return 0
  fi

  return 1
}

function installZipApp () {
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

function installJDKEnv () {
  if yesNoQuestion "Install JDK environment?"; then
    brew cask install java
    brew install maven
  fi
}

function installNodeJSEnv () {
  if yesNoQuestion "Install Node.js environment?"; then
    brew install node

    username=$(whoami)
    primary_group=$(id -g -n $username)
    echo "Asking for permission to change the \"/usr/local\" owner to actual user."
    sudo chown $username:$primary_group /usr/local

    # Use NVM to manage NodeJS versions
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    # Install usefull packages
    npm install -g npm-check-updates
    # npm install -g eslint-cli
  fi
}

# This function will not allow you to install (or even purchase) an app for the first time: it must already be in the Purchased tab of the App Store.
function installAppStoreApp () {
  if yesNoQuestion "Install \"$1\"?"; then
    mas install $2
  fi
}

function installApplications () {
  # Install applications and utils
  installHomebrew

  #brew install tmux
  brew install sshpass
  brew install --cask raycast

  installJDKEnv
  installNodeJSEnv

  # installZipApp "BetterTouchTool" "https://www.boastr.net/releases/BetterTouchTool.zip"
  # installZipApp "SourceTree" "https://downloads.atlassian.com/software/sourcetree/SourceTree_2.4.1a.zip"

  installCaskApp "visualvm"
  installCaskApp "google-chrome"
  #installCaskApp "sourcetree"
  installCaskApp "visual-studio-code"
  #installCaskApp "intellij-idea-ce"
  installCaskApp "intellij-idea"
  installCaskApp "firefox"
  installCaskApp "meocloud"
  installCaskApp "dropbox"
  installCaskApp "onedrive"
  installCaskApp "libreoffice"
  installCaskApp "gimp"
  installCaskApp "spotify"
  #installCaskApp "real-vnc"
  installCaskApp "caffeine"
  installCaskApp "docker"

  installAppStoreApp "LanScan" "472226235"
  installAppStoreApp "Microsoft OneNote" "784801555"
}

function cleanUpInstallationCaches () {
  brew cleanup --force -s && rm -rf $(brew --cache)
}