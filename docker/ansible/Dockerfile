# =============
# Ansible worker
# Run playbooks from this container
# =============
FROM python:3-alpine

ARG ANSIBLE_VERSION VAULT
ENV ANSIBLE_VERSION=${ANSIBLE_VERSION:-4.3.0}

RUN apk update && \
    apk upgrade &&  \
    apk add --no-cache --update libffi-dev \
        py-netaddr openssh sshpass zip

RUN mkdir -p /etc/ansible

WORKDIR  /etc/ansible
COPY ./ansible-entrypoint.sh .

ENTRYPOINT ["ansible-entrypoint.sh"]
