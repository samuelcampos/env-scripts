#!/bin/bash

function installAPTApp {
  if yesNoQuestion "Install \"$1\"?"; then
    sudo apt-get install $1
    return 0
  fi

  return 1
}

function installApplications {
  # check if this distribution uses "apt-get"
  if which apt-get > /dev/null; then
    sudo apt-get update
  
    installAPTApp "kodi"
    installAPTApp "realvnc-vnc-server"
    installAPTApp "libreoffice"
  fi
  
}

function cleanUpInstallationCaches {

}