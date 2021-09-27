#!/usr/bin/env bash

# Script installing common packages
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install --no-install-recommends apt-transport-https \
                    ca-certificates \
                    software-properties-common \
                    python3-pip \
                    python3-setuptools

sudo pip3 install ansible
# Minimal bash shell Config
echo "Adding base shell config for $(whoami)"
sudo mv /tmp/res/.bash_aliases ~/.bash_aliases
sudo mv /tmp/res/.bashrc ~/.bashrc
sudo rm -rf /tmp/res

# Work around permissions issues
#mkdir -p /usr/share/
#chown -R vagrant:vagrant 775 /usr/share/
