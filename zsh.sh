#!/bin/bash

usr=lastico
pass=janVanHelsing69
curr="$(whoami)"
# configure my ssh keys
/bin/bash ./keys.sh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<EOF
Y
Y
EOF

nr=~/vps-init/res
cp -rf $nr/.vimrc ~/
cp -rf $nr/.gitconfig ~/
sudo rm -rf -rf /etc/motd
sudo cp $nr/motd /etc/
cp -rf $nr/.zsh_aliases ~/


# dnsmasq
# 213.136.95.10
# 213.136.95.11