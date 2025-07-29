#!/bin/bash

ENV_SCRIPT_NAME="env-scripts"
ENV_SCRIPT_VERSION="0.0.1"

LOCAL_PATH="$(pwd)"
OS_FOLDER=""

# Check if the file has already been changed by this script
function fileChanged () {
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
function printFileChangeSignature () {
  printf "\n\n# (%s-%s) Include default known hosts\n"\
        "$ENV_SCRIPT_NAME"\
        "$ENV_SCRIPT_VERSION"\
        >> $1
}

function setupSSHConfig () {
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

function installZSH () {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function setupBashProfile () {
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

function setupBashRC () {
  BASH_RC_FILE="$HOME/.zshrc"

  fileChanged $BASH_RC_FILE
  case $? in
    [1-2]*)
      printFileChangeSignature $BASH_RC_FILE

      echo "source $LOCAL_PATH/rc-files/common.sh" >> $BASH_RC_FILE

      # If java is installed
      if which java > /dev/null; then
        echo "source $LOCAL_PATH/rc-files/java.sh" >> $BASH_RC_FILE
      fi

      # If docker is installed
      if which docker > /dev/null; then
        echo "source $LOCAL_PATH/rc-files/docker.sh" >> $BASH_RC_FILE
      fi
      ;;
    3*)
      # File already changed - Update?
      ;;
  esac  
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

source ./rc-files/common.sh
source ./$OS_FOLDER/functions.sh

installApplications
cleanUpInstallationCaches

# Configure some bash files
setupSSHConfig
setupBashProfile
setupBashRC