usr=lastico
pass=janVanHelsing69

apt-get update
apt-get install sudo

adduser $usr << 'EOF'
${pass}
${pass} 
Roux
69



Y
EOF

usermod -aG sudo $usr 
su - $usr 
id $usr 

echo "please run ssh-copy-id lastico@144.91.67.171 on your machine" && logout
