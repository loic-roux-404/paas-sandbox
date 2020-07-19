# =============
# Ansible worker
# Run playbooks from this container
# =============
FROM alpine:latest

ARG PRIV
ENV ANSIBLE_VERSION=2.9.9-r0 YQ_VERSION=3.3.2 PRIV=${PRIV}

RUN apk update && \
    apk upgrade &&  \
    apk add --no-cache --update ansible=${ANSIBLE_VERSION} libffi-dev py-netaddr openssh sshpass zip make bash wget \
    && wget -qO /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" \
    && chmod +x /usr/local/bin/yq
# Clean non needed
RUN apk del wget

COPY init.bash /root/
RUN chmod +x /root/init.bash \
    && PRIV=${PRIV} /root/init.bash \
    && rm -rf /root/init.bash

RUN mkdir -p /etc/ansible
RUN mkdir -p /playbook
WORKDIR /playbook

ENTRYPOINT ["/bin/bash"]
