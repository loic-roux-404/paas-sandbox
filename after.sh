usr=lastico
pass=janVanHelsing69


su $usr <<EOF
$pass
EOF

sudo -s

#ssh configure
echo '
ChallengeResponseAuthentication no 
PasswordAuthentication no
UsePAM no
PermitRootLogin no' >> /etc/ssh/sshd_config

/etc/init.d/ssh reload
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
    zsh \

service dnsmasq start

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   nightly"

apt --assume-yes install docker-ce docker-ce-cli containerd.io docker-compose
service docker start

# TODO : automatic dns docker config
#touch /etc/network/interfaces.d/dockerdns0
# https://www.howtoforge.com/how-to-deploy-a-dynamic-dns-server-with-docker-on-debian-10/#step-updating-and-installing-dependencies
su $usr
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<EOF
Y
Y
EOF
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
    mv res/.zsh_aliases ~/
else
  echo "Please check the location of vpm-init repo"
fi

# dnsmasq
#213.136.95.10
#213.136.95.11