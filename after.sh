usr=lastico
pass=janVanHelsing69

#ssh configure
sudo echo '
ChallengeResponseAuthentication no 
PasswordAuthentication no
UsePAM no
PermitRootLogin no' >> /etc/ssh/sshd_config

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
    software-properties-common \
    dnsutils
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   nightly"

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose

sudo service docker stop
rm -rf /etc/docker/daemon.json
touch /etc/docker/daemon.json
sudo echo '{
  "debug": true,
  "tls": true,
  "dns": ["10.0.0.2", "8.8.8.8"],
  "tlscert": "/var/docker/server.pem",
  "tlskey": "/var/docker/serverkey.pem",
  "hosts": ["tcp://192.168.59.3:2376"]
}' >> /etc/docker/daemon.json

sudo service docker start

# TODO : automatic dns docker config
#touch /etc/network/interfaces.d/dockerdns0

git clone git@github.com:anthraxx/ant-zsh.git ~/ant-zsh/
make -C ~/ant-zsh/ install
rm -rf ~/ant-zsh/

if [ -f res/ ]; then
    echo $pass | sudo -s
    rm -rf ~/
    mv res/.vimrc ~/
    mv res/.gitconfig ~/
    rm -rf /etc/motd
    mv res/motd /etc/
else
  echo "Please check the location of vpm-init repo"
fi
