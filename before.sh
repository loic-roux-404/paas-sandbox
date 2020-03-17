#!/bin/bash

usr=lastico # TODO use env variable to assign
pass=janVanHelsing69 # TODO use env variable to assign
curr = cat $(whoami) 

if [ $curr -ne "root"]
    echo "Please execute this script as root"
    return
fi

apt-get update
apt-get install sudo

adduser $usr <<EOF
$pass
$pass





Y
EOF

r=/home/$usr
cp -r /root/vps-init $r
chown -R $usr:$usr $r
usermod -aG sudo $usr

echo "please run echo ssh-copy-id lastico@144.91.67.171 on your machine" && logout
