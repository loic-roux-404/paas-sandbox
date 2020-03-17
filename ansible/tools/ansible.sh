#!/bin/bash
debian_version=$(cat /etc/debian_version)
ansible_installed=$(which ansible | wc -l)

if [ "$ansible_installed" -eq 0 ]; then
  # Add ansible 2.6 repository and install ansible
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
  sudo apt update -y
  sudo apt install -y ansible
else
  echo "Ansible is already installed."
fi

echo "==> Ansible version <=="
ansible --version
echo "==> Ansible version <=="
apt-get update \
apt-get install git
