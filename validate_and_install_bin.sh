#!/bin/bash

# User root
if [ ! `whoami` == 'root' ]; then
    echo I am not root
    exit   
fi

# List binaries
BINARY=( jq sponge )

# Function validate OS Release
OS_RELEASE(){
    OS=$(cat /etc/*-release | grep ID=debian)
    if [ $OS == "ID=debian" ]; then
      echo "debian"
      apt install $1 -y
    else
      echo "centos"
      yum install $1 -y
    fi
}

# Function that validates the binary installation
VALIDATE_INSTALL_BIN() {
  if [ -z $(which $1) ] ; then
      echo "Installing binary $1"
      OS_RELEASE $1
  else
      echo "$1 binary already installed"
  fi
}

# Loop that traverses the array
for i in "${BINARY[@]}"
do
    VALIDATE_INSTALL_BIN "$i"
done
