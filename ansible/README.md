
TO DO
------------
- [ ] Immutable and secure sudoers
- [x] [Role ledokku] dokku role preconf + ledokku ui + github secret + cron change jwt
- [ ] Vault / docker secrets
- [ ] Monitoring
- [ ] Scaling
- [ ] Replace actual role-zsh with https://github.com/gantsign/ansible-role-oh-my-zsh

### Init stack

- If server not provisionned `brew install esolitos/ipa/sshpass`
- `conda create -y -n=$(basename "$PWD") python=3.8`
- `conda activate $(basename "$PWD")`
- `make install`

To Provision of a server from scratch `make site ANSIBLE_VARS='ansible_user=root ansible_password=root-pass'`

Creates :
- security config
- user creation
- shell environment and utilities
- docker and dokku
- monitoring tools (not yet implemented)

Roles used by sub-playbook:
------------

### Stack :

Simple playbook to create shell / users and install language tools

- role-shell (comport ansible-zsh role)
- role-tools
- role-dns for more configurable dnsmasq

### Security :

Secure the infrastructure client / server instances

- **role-basics** with deps : weareinteractive.users
- role-firewall (jeff g.)
- role-security (jeff g.)

### Swarm :

--> Objective is to build a simple configuration on top of playbook-paas sub playbooks to provide container orchestration and envs (staging / prod) for apps

Later it's can be more logical to split server in two nodes with a master custer and client one

- role-dns
- role-dokku : PaaS tool

#### Monitoring

Use prometheus to measure apps performances and alerts when issues appears.

For functionnal monitoring playbook, we need the following things, just type commands :

- `pip install -r requirements.txt`
- `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES`
- `brew install gnu-tar` (mac os)

> Check requirements

- role-logrotate

### Secure user creation

1. `htpasswd -nb vagrant toto`
1.  Open `ansible-vault edit inventories/paas/group_vars/all/secrets`
1. `user1.password: $apr1$4mjrgol9$toKJeYzjKhS3qcWJl8Tvb`

### Troubleshoot

**Mac Os**

To fix debug vagrant dns issues : `sudo killall -HUP mDNSResponder`

Requirements
------------

`make` give an help

`make install`

For first deploy of this playbook : `make site ANSIBLE_VARS=ansible_user=root`

See [Makefile](Makefile) for debugging and full deploy on a server

Author Information
------------------

[Loic Roux](https://github.com/loic-roux-404)
