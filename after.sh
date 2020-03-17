#!/bin/bash

usr=lastico
pass=janVanHelsing69
curr= `whoami`

# first for updates switch to root user
if [ $curr -ne $usr]
    echo "Please execute this script as ${usr}"
    return
fi

echo '-----starting------'
sudo rm -rf /root/vps-init;

#ssh configure
sudo su - root -c "echo '
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
PermitRootLogin no' >> /etc/ssh/sshd_config"

sudo /etc/init.d/ssh reload
sudo systemctl reload ssh

sudo apt-get --assume-yes update
sudo apt-get --assume-yes install  \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    dnsmasq \
    dnsutils \
    vim \
    zsh \
    make

sudo service dnsmasq start

sudo curl -fsSL https://download.docker.com/linux/debian/gpg | runr apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   'deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   nightly'

sudo apt --assume-yes install docker-ce docker-ce-cli containerd.io docker-compose
sudo sudo service docker start

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
git clone git@github.com:anthraxx/ant-zsh.git ~/ant-zsh/
make -C ~/ant-zsh/ install
rm -rf ~/ant-zsh/

chsh --shell /usr/bin/zsh lastico
echo '-----Setup ready------'
zsh 
# dnsmasq
#213.136.95.10
#213.136.95.11