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
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
      echo "Homebrew is already installed!"
      brew update && brew doctor && brew upgrade
  fi

  # Install Homebrew basic applications
  brew install bash-completion
}

function installBrewApp () {
  if yesNoQuestion "Install \"$1\"?"; then
    brew install $1
    return 0
  fi

  return 1
}

function installCaskApp () {
  if yesNoQuestion "Install \"$1\"?"; then
    brew install --cask $1
    return 0
  fi

  return 1
}

function installJDKEnv () {
  if yesNoQuestion "Install JDK environment?"; then
    brew install --cask "temurin@21"
    
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

  installJDKEnv
  installNodeJSEnv

  installCaskApp "visualvm"
  installCaskApp "google-chrome"
  installCaskApp "visual-studio-code"
  installCaskApp "intellij-idea-ce"
  installCaskApp "intellij-idea"
  installCaskApp "firefox"
  installCaskApp "meocloud"
  installCaskApp "dropbox"
  installCaskApp "onedrive"
  installCaskApp "libreoffice"
  installCaskApp "gimp"
  installCaskApp "spotify"
  installCaskApp "caffeine"
  installCaskApp "docker"
  installCaskApp "raycast"
  installCaskApp "tailscale"
  installCaskApp "miro"

  installBrewApp sshpass
  installBrewApp awscli
  installBrewApp derailed/k9s/k9s

  # Apple App Store apps
  # "mas" is the command to install apps from AppStore
  brew install mas

  installAppStoreApp "LanScan" "472226235"
  installAppStoreApp "Microsoft OneNote" "784801555"
}

function cleanUpInstallationCaches () {
  brew cleanup -s && rm -rf $(brew --cache)
}
