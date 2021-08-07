#!/bin/bash -eux

# Delete all Linux headers
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers' \
  | xargs apt-get -y purge;

# Remove specific Linux kernels, such as linux-image-3.11.0-15 but
# keeps the current kernel and does not touch the virtual packages,
# e.g. 'linux-image-amd64', etc.
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-[234].*' \
    | grep -v `uname -r` \
    | xargs apt-get -y purge;

# Delete Linux source
dpkg --list \
    | awk '{ print $2 }' \
    | grep linux-source \
    | xargs apt-get -y purge;

# Delete development packages
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-dev$' \
    | xargs apt-get -y purge;

# Delete oddities
apt-get -y purge popularity-contest;

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

# Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
truncate -s 0 /etc/machine-id

# clear the history so our install isn't there
export HISTSIZE=0
rm -f /root/.wget-hsts

apt-get -y remove \
    ppp \
    pppconfig \
    pppoeconf \
    cpp \
    gcc \
    g++ \
    libx11-data \
    xauth \
    libxmuu1 \
    libxcb1 \
    libx11-6 \
    libxext6 \
    linux-source \
    python-pip \
    python-dev \
    python \
    python2.7 \
    dctrl-tools \

# Clean up
# Apt cleanup.
apt-get -y autoremove;
apt-get -y clean;
apt-get autoclean -y;

# remove generated cache
sudo rm -rf /var/cache/apt/*
rm -f /home/vagrant/*.sh

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

sudo dpkg --purge --force-all installation-report || true
sudo journalctl --vacuum-size=100M -q

# Removing leftover leases and persistent rules
echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync