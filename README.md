Playbook-vps
============
ENV :

&rarr; Simple playbook to create shell / users / ssh keys from github

Security:
&rarr; Securise anyone of the linux instances of the infrastructure

Stack :

--> Objective is to build a simple configuration on top of playbook-vps sub playbooks to provide container
orchestration and per env applications system

TO DO
------------
- list a test host file
- Create consul cluster before vault and unidirectional connect
- Secure nomad with vault
- Configure security role

**Less emergency**
- nodejs + NVM to build assets (should go on docker python venv)
- Nomad Simple container management system
- Link to applications and their artifacts (logs)
- UI to manage deployments between different environments => auto CI deploy template
- Vault system with dynamic secret and project protection
- Vault CA Authority
- Make app playbook template with nomad job

Roles used by sub-playbook:
------------

### Env :

- role-basics with deps : ansible-role-zsh & weareinteractive.users

### Security :

- firewall (jeff g.)
- ssh (jeff g.)

### Stack :

Later it's can be more logical to split server in two nodes with a master custer and client one

- role-docker
- role-nomad → https://github.com/loic-roux-404/role-nomad
- role-traefik → https://github.com/kibatic/ansible-traefik # LATER
- role-vault → https://github.com/loic-roux-404/role-vault
- role-consul
- logrotate # Later with at least one configured app

### Vault :

Vault instance is hosted on heroku container

1. `heroku container:login`
1. `PUB=$(cat ~/.ssh/id_rsa.pub) heroku container:push vault -a acl-vault`
1. `heroku container:release -a acl-vault`

Requirements
------------

`make install`

See [Makefile](Makefile) for debugging and full deploy on a server

License
-------

BSD

Author Information
------------------

[Loic Roux]()
