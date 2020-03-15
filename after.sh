#ssh configure
sudo echo '
ChallengeResponseAuthentication no 
PasswordAuthentication no
UsePAM no
PermitRootLogin no
Port 69' >> /etc/ssh/sshd_config

sudo echo '{
  "debug": true,
  "tls": true,
  "tlscert": "/var/docker/server.pem",
  "tlskey": "/var/docker/serverkey.pem",
  "hosts": ["tcp://192.168.59.3:2376"]
}' >> /etc/docker/daemon.json

/etc/init.d/ssh reload
sudo systemctl reload ssh

# install ansible
deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo apt update
sudo apt install ansible

sudo apt update
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   nightly"

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

# after install zsh
curl https://raw.githubusercontent.com/viasite-ansible/ansible-role-zsh/master/install.sh | bash
