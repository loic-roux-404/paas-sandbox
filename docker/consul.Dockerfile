# ==================
# Docker container to host simple service
# Use Ansible to update
# ==================
FROM debian:stable
MAINTAINER Loïc Roux <loic.roux.404@gmail.com>

ARG PUB

ENV PUB=${PUB} USER=consul PASS=consul

RUN useradd -m ${USER} && echo "${USER}:${PASS}" | chpasswd && adduser ${USER} sudo

RUN if [ "$PUB" = '' ]; then echo "\033[0;31mMissing env var PUB" && exit 1 ; fi; \
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
    && ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_key \
    && mkdir -p /home/${USER}/.ssh/ \
    && echo -n ${PUB} > /home/${USER}/.ssh/authorized_keys \
    && chmod 400 /home/${USER}/.ssh/authorized_keys && chown -R "${USER}:${USER}" /home/${USER}/.ssh/

CMD ["/usr/sbin/sshd","-D"]

EXPOSE 22

EXPOSE 8300

EXPOSE 8301 8301/udp 8302 8302/udp

EXPOSE 8500 8600 8600/udp
