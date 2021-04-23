Playbook-vps
============

TO DO
------------
- [ ] Test coolify

**Less emergency**

- Nomad Simple container management system
- UI to manage deployments between different environments => auto CI deploy template
- Vault system with dynamic secret and project protection
- Vault CA Authority
- Make app playbook template with nomad job
- split app logs

### Init stack

- `conda create --name=$(basename "$PWD") python=3.8`
- `conda activate $(basename "$PWD")`
- `pip install -r requirements.txt`

- First do `make site` (`make site.debug` to test on vm). It install users and apply security configs like for ssh.

Roles used by sub-playbook:
------------

### Env :

Simple playbook to create shell / users / ssh keys from github

- **role-basics** with deps : ansible-role-zsh & weareinteractive.users

### Security :

Secure the infrastructure client / server instances

- role-firewall (jeff g.)
- role-security (jeff g.)

### Stack :

--> Objective is to build a simple configuration on top of playbook-vps sub playbooks to provide container orchestration and envs (staging / prod) for apps

Later it's can be more logical to split server in two nodes with a master custer and client one

#### Monitoring

Use prometheus to measure apps performances and alerts when issues appears.

For functionnal monitoring playbook, we need the following things, just type commands :

- `pip install -r requirements.txt`
- `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES`
- `brew install gnu-tar`

> Check requirements

- role-docker
- role-logrotate

### Secure user creation

1. `htpasswd -nb vagrant toto`
1.  Open `ansible-vault edit inventories/vps/group_vars/all/secrets`
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

License
-------

BSD 3

Author Information
------------------

[Loic Roux](https://github.com/loic-roux-404)
