# ==================
# Docker container to host vault
# Use Ansible to update
# ==================
FROM debian:stable
MAINTAINER Loïc Roux <loic.roux.404@gmail.com>

ARG PUB='' PORT=8200

ENV VAULT_ADDR=http://0.0.0.0:8200 PUB=${PUB}

EXPOSE 8200 22

RUN if [ "$PUB" = '' ]; then echo "\033[0;31mMissing env var PUB" && exit 1 ; fi; \
    apt-get update -y && apt-get upgrade -y && apt-get install -y \
        python3 \
        openssh-server \
    && rm -rf /var/apt/cache/* \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd \
    && sed -ie 's/#Port 22/Port 22/g' /etc/ssh/sshd_config \
    && sed -ie 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config \
    && sed -ie 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
    && sed -ri 's/#HostKey \/etc\/ssh\/ssh_host_key/HostKey \/etc\/ssh\/ssh_host_key/g' /etc/ssh/sshd_config \
    && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/g' /etc/ssh/sshd_config \
    && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_dsa_key/HostKey \/etc\/ssh\/ssh_host_dsa_key/g' /etc/ssh/sshd_config \
    && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config \
    && sed -ir 's/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g' /etc/ssh/sshd_config \
    && /usr/bin/ssh-keygen -A \
    && ssh-keygen -t rsa -b 4096 -f  /etc/ssh/ssh_host_key \
    && mkdir -p /root/.ssh \
    && echo -n ${PUB} >> /root/.ssh/authorized_keys

CMD ["/usr/sbin/sshd","-D"]
