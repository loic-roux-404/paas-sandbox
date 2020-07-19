# ==================
# Docker container to host simple server hashistack instance
# Use Ansible to update
# ==================
FROM debian:stable
MAINTAINER Loïc Roux <loic.roux.404@gmail.com>

ARG PUB

ENV PUB=${PUB} USER=consul PASS=consul

COPY scripts /root/scripts

RUN chmod +x /root/scripts/* \
    && /root/scripts/user.sh \
    && /root/scripts/ssh_server.sh \
    && /root/scripts/authorized_key.sh \
    && rm -rf /root/scripts

CMD ["/usr/sbin/sshd","-D"]

EXPOSE 22

EXPOSE 8300

EXPOSE 8301 8301/udp 8302 8302/udp

EXPOSE 8500 8600 8600/udp
