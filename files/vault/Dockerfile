# ==================
# Docker container to host vault
# Provisionned By Ansible
# ==================
FROM alpine:3.9
MAINTAINER Loïc Roux <loic.roux.404@gmail.com>

ENV VAULT_ADDR=http://0.0.0.0:8200

EXPOSE 8200

RUN apk add --update bash git make && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["bash"]
