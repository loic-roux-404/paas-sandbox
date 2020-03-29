#!/bin/bash
debian_version=$(cat /etc/debian_version)
ansible_installed=$(which ansible | wc -l)
ENABLE_AUTO_PROVISION=0
GIT_USER='loic-roux-404'
REPONAME='playbook-vps'

if [ "$ansible_installed" -eq 0 ]; then

  deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main

  # Add ansible 2.6 repository and install ansible
sudo add-apt-repository ppa:ansible/ansible-2.9
sudo apt-get update
sudo apt-get -y install ansible

else
  echo "Ansible is already installed."
fi

echo "[ ---- Ansible version installed ---- ]"
ansible --version
echo "[ ---- Start provisionning local ---- ]"

if [ $ENABLE_AUTO_PROVISION -eq 1 ]; then
  git clone https://github.com/$GIT_USER/$REPONAME.git
  cd $REPONAME
  make install
  make site
fi
