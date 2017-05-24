#!/bin/bash

ARCH=$(/usr/libexec/java_home)

if [[ $OSTYPE != linux* ]] || [[ $ARCH != arm* ]]; then
    echo "This is not a Linux with ARM architecture!"
    exit 1
fi

sudo apt-get install libx11-dev
sudo apt-get install git build-essential

mkdir -p $HOME/Development/
cd $HOME/Development/
git clone https://github.com/microsoft/vscode
cd vscode
./scripts/npm.sh install --arch=armhf

./scripts/code.sh