#!/bin/bash

function installAPTApp () {
  if yesNoQuestion "Install \"$1\"?"; then
    sudo apt-get install $1
    return 0
  fi

  return 1
}

function installNodeJSEnv () {
  if yesNoQuestion "Install Node.js environment?"; then
    # http://thisdavej.com/beginners-guide-to-installing-node-js-on-a-raspberry-pi/#install-node
    OUTPUT=$(uname -m)
    case "$OUTPUT" in
      x86_64*)
        ;;
      armv7l*)
        curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
        ;;
    esac

    sudo apt install nodejs
    return 0
  fi

  return 1
}

function installApplications () {
  # check if this distribution uses "apt-get"
  if which apt-get > /dev/null; then
    sudo apt-get update
  
    installAPTApp "kodi"
    installAPTApp "realvnc-vnc-server"
    installAPTApp "libreoffice"
    installAPTApp "maven"

    installNodeJSEnv
  else
    echo "Linux version not supported!"
    exit 2
  fi
  
}

function cleanUpInstallationCaches () {
  echo
}
