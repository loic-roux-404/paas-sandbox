# ==================
# Docker container to host simple server hashistack instance
# Use Ansible to update
# ==================
FROM debian:stable
MAINTAINER Loïc Roux <loic.roux.404@gmail.com>

ARG PUB

ENV PUB=${PUB} USER=vault PASS=vault

COPY init.sh /root/init.sh

RUN chmod +x /root/init.sh && /root/init.sh && rm -rf /root/init.sh

CMD ["/usr/sbin/sshd","-D"]

EXPOSE 22

EXPOSE 8200
