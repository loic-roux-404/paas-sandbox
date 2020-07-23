# ==================
# Docker container to host simple server hashistack instance
# Use Ansible to update
# ==================
FROM debian:stable
MAINTAINER Loïc Roux <loic.roux.404@gmail.com>

ARG PUB PRIV

ENV PUB=${PUB} PRIV=${PRIV} USER=nomad PASS=nomad

COPY init.bash /root/
RUN chmod +x /root/init.bash \
    && PRIV=${PRIV} PUB=${PUB} /root/init.bash true \
    && rm -rf /root/init.bash

CMD ["/usr/sbin/sshd","-D"]

EXPOSE 22

EXPOSE 4646 4647 4648 4648/udp
