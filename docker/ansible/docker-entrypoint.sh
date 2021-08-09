#!/usr/bin/env bash
set -e
###################
#
# Ansible entrypoint : install deps and run ansible-playbook
#
###################

if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi

if [ -f requirements.yaml ]; then
    ansible-galaxy install -r requirements.yaml
fi

if [ -f $VAULT ]; then
    echo -n ${VAULT} > vault_pass.sh
fi

ansible-playbook "$@"
