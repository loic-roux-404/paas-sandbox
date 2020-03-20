#!/bin/bash
debian_version=$(cat /etc/debian_version)
ansible_installed=$(which ansible | wc -l)

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