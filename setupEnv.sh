#!/bin/bash

ENV_SCRIPT_NAME="env-scripts"
ENV_SCRIPT_VERSION="0.0.1"

TEMP_FOLDER="$HOME/Downloads/"

LOCAL_PATH="$(pwd)"
OS_FOLDER=""

# Check if the file has already been changed by this script
function fileChanged {
  if [ ! -f "$1" ]; then
    # File not found!
    return 1
  fi

  if grep -Fq "$ENV_SCRIPT_NAME" $1
  then
      # File already changed!
      return 3
  else
      # File not changed!
      return 2
  fi
}

# This method prints a change signature (in order to check if the file was changed by this script)
function printFileChangeSignature {
  printf "\n\n# (%s-%s) Include default known hosts\n"\
        "$ENV_SCRIPT_NAME"\
        "$ENV_SCRIPT_VERSION"\
        >> $1
}

function setupSSHConfig {
  SSH_CONFIG_FILE="$HOME/.ssh/config"

  fileChanged $SSH_CONFIG_FILE
  case $? in
    [1-2]*)
      printFileChangeSignature $SSH_CONFIG_FILE

      # ssh >= 7.3p1 (released on August 1st, 2016)
      # Use "ssh -V" to check
      printf "Include $LOCAL_PATH/.ssh/config\n"\
        >> $SSH_CONFIG_FILE
      ;;
    3*)
      # File already changed - Update?
      ;;
  esac
}

function installZSH {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function setupBashProfile {
  BASH_PROFILE_FILE="$HOME/.bash_profile"

  fileChanged $BASH_PROFILE_FILE
  case $? in
    [1-2]*)
      printFileChangeSignature $BASH_PROFILE_FILE

      cat ./$OS_FOLDER/.bash_profile >> $BASH_PROFILE_FILE
      ;;
    3*)
      # File already changed - Update?
      ;;
  esac  
}

function yesNoQuestion {
  while true
  do
    read -p "$1 (y/n) " -n 1 choice
    echo 
    case "$choice" in 
      y|Y ) 
        return 0
        ;;
      n|N )
        return 1
        ;;
      * ) echo "invalid option";;
    esac
  done
}


# Start script

case "$OSTYPE" in
  solaris*)
    echo "SOLARIS not supported yet"
    exit 1
    ;;
  darwin*)
    OS_FOLDER="macOS"
    installZSH   
    ;;
  linux*)
    OS_FOLDER="linux"
    ;;
  bsd*)
    echo "BSD not supported yet"
    exit 1
    ;;
  msys*)
    echo "WINDOWS not supported yet"
    exit 1
    ;;
  *)
    echo "unknown: $OSTYPE not supported yet"
    exit 1
    ;;
esac

source ./$OS_FOLDER/functions.sh

installApplications
cleanUpInstallationCaches

# Configure some bash files
setupSSHConfig
setupBashProfile