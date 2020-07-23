# ==================
# Docker container to host simple server hashistack instance
# Use Ansible to update
# ==================
FROM debian:stable
MAINTAINER Loïc Roux <loic.roux.404@gmail.com>

ARG PUB PRIV

ENV PUB=${PUB} PRIV=${PRIV} USER=consul PASS=consul

COPY init.bash /root/
RUN chmod +x /root/init.bash \
    && PRIV=${PRIV} PUB=${PUB} /root/init.bash true \
    && rm -rf /root/init.bash

CMD ["/usr/sbin/sshd","-D"]

EXPOSE 22

EXPOSE 8300

EXPOSE 8301 8301/udp 8302 8302/udp

EXPOSE 8500 8600 8600/udp
