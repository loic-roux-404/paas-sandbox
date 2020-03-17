#!/bin/bash

usr=lastico
pass=janVanHelsing69
curr="$(whoami)"

# first for updates switch to root user
if [[ "$curr" != "$usr" ]]
then
    echo "Please execute this script as ${usr}"
    exit
else
    echo '----- starting ------'
fi

sudo rm -rf /root/vps-init<<EOF
$pass
EOF

# configure my ssh keys
/bin/bash ./keys.sh

#ssh configure
# TODO: use sed to replace lines instead of appending more text

sudo apt --assume-yes update
sudo apt --assume-yes install  \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    dnsutils \
    zsh \
    make

# TODO : automatic dns docker config
#touch /etc/network/interfaces.d/dockerdns0
# https://www.howtoforge.com/how-to-deploy-a-dynamic-dns-server-with-docker-on-debian-10/#step-updating-and-installing-dependencies

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

chsh --shell /usr/bin/zsh lastico<<EOF
$pass
EOF
echo '-----Setup ready------'
#sudo rm -rf ~/vps-init/
zsh

# dnsmasq
# 213.136.95.10
# 213.136.95.11