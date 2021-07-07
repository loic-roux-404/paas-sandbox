#!/bin/bash
# ============
# init container script
# Usage PRIV=(id_rsa) PUB=(authorized_key) ./init.bash [ssh-server (bool)]
# ============

# [Only debian] : Create user
if [ ! -z "$USER" ]
then
    useradd -s /bin/bash -m ${USER} \
    && echo "${USER}:${PASS}" | chpasswd && adduser ${USER} sudo
fi

# [Only debian] : Install ssh-server
if [ "$1" = 'true' ]
then
    apt-get update -y && apt-get upgrade -y && apt-get install -y \
        python3 \
        openssh-server \
        sudo \
    && rm -rf /var/apt/cache/* \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd \
    && sed -ie 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -ie 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
    && sed -ri 's/#HostKey \/etc\/ssh\/ssh_host_key/HostKey \/etc\/ssh\/ssh_host_key/g' /etc/ssh/sshd_config \
    && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config \
    && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config \
    && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config \
    && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config \
    && /usr/bin/ssh-keygen -A \
    && ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_key
fi

# =========
# [Alpine / debian] : echo private key in an user ssh dir
# =========
# generate file from implicit / explicit text content (cat pipe/ env var)
gen_file() {
    CONTENT=$1
    DEST_DIR=$2
    DEST_FILE=$3
    CHMOD=${4:-600}

    mkdir -p ${DEST_DIR} \
        && echo -n ${CONTENT} >> ${DEST_DIR}/${DEST_FILE};
    if [ ! -z "$USER" ]; then chown -R ${USER}:${USER} ${DEST_DIR}; fi;
    chmod 700 ${DEST_DIR} \
        && chmod ${CHMOD} ${DEST_DIR}/${DEST_FILE};
}

SSH_PATH=/root/.ssh

if [ -z "$USER" ]; then USER=root; fi

if [ ! "$USER" = 'root' ]; then SSH_PATH=/home/${USER}/.ssh; fi;

if [ ! -z "$PUB" ]; then gen_file "${PUB}" ${SSH_PATH} authorized_keys; fi;

if [ ! -z "$PRIV" ]; then gen_file "${PRIV}" ${SSH_PATH} id_rsa; fi;
