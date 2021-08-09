# Core stack

Core component of self hosted PaaS stack Hosted on heroku.

# Vault

# Ansible worker
> Run from repo root

- `docker build docker/ansible -t ansibleworker:1.0 -t ansibleworker:latest`
- `docker run -ti --rm -v $(pwd)/ansible:/etc/ansible ansibleworker:1.0`

# Deploy
