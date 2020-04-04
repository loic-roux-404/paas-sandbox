Playbook-vps
============
ENV : 

&rarr; Simple playbook to create shell / users / ssh keys from github

Security:
&rarr; Securise anyone of the linux instances of the infrastructure

Stack :

--> Objective is to build a simple configuration on top of playbook-vps sub playbooks to provide container
orchestration and per env applications system

TODO
------------
- nodejs
- Nomad Simple container management system
- Link to applications and their artifacts (database / logs)
- UI to manage deployments between different environments
- Vault system with dynamic secret and project protection
- Vault CA Authority
- Secure nomad with vault
- Subdomains attribution with traefik
- split playbooks

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
- role-vault → https://github.com/loic-roux-404/role-vault # LATER
- consul also lateerrr
- logrotate # Later with at least one configured app

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