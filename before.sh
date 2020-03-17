#!/bin/bash

usr=lastico # TODO use env variable to assign
pass=janVanHelsing69 # TODO use env variable to assign
curr="$(whoami)"

if [ $curr = "root" ]
then
    echo "------First step : create user-------";
else
    echo "Please execute this script as root";
    exit;
fi

apt-get update
apt-get --assume-yes install sudo vim

adduser $usr <<EOF
$pass
$pass





Y
EOF

r=/home/$usr
cp -r /root/vps-init $r
chown -R $usr:$usr $r
usermod -aG sudo $usr

echo "please run 'ssh-copy-id lastico@144.91.67.171' on your machine"
# exit and append commands
exit
