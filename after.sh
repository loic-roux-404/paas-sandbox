usr=lastico
pass=janVanHelsing69

function runr() {
  sudo su - root -c "${1}"
}

# first for updates switch to root user
echo "\n\n$(whoami)\n\n"
runr rm -rf /root/vps-init;

#ssh configure
runr echo '
ChallengeResponseAuthentication no 
PasswordAuthentication no
UsePAM no
PermitRootLogin no' >> /etc/ssh/sshd_config

runr '/etc/init.d/ssh reload'
runr systemctl reload ssh

runr apt-get --assume-yes update 
runr apt-get --assume-yes install  \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    dnsmasq \
    dnsutils \
    zsh \

runr service dnsmasq start

runr curl -fsSL https://download.docker.com/linux/debian/gpg | runr apt-key add -
runr apt-key fingerprint 0EBFCD88

runr add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   nightly"

runr apt --assume-yes install docker-ce docker-ce-cli containerd.io docker-compose
runr sudo service docker start

# TODO : automatic dns docker config
#touch /etc/network/interfaces.d/dockerdns0
# https://www.howtoforge.com/how-to-deploy-a-dynamic-dns-server-with-docker-on-debian-10/#step-updating-and-installing-dependencies

# second install user tools
sudo su - $usr<<EOF
$pass
EOF

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<EOF
Y
Y
EOF

git clone git@github.com:anthraxx/ant-zsh.git ~/ant-zsh/
make -C ~/ant-zsh/ install
rm -rf ~/ant-zsh/

nr=~/vps-init/res

usermod -s /usr/bin/zsh $usr

runr mv -f $nr/.vimrc ~/
runr mv -f $nr/.gitconfig ~/
runr rm -f -rf /etc/motd
runr mv -f $nr/motd /etc/
runr mv -f $nr/.zsh_aliases ~/

# dnsmasq
#213.136.95.10
#213.136.95.11