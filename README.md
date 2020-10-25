Playbook-vps
============
#### ENV :

Simple playbook to create shell / users / ssh keys from github

#### Security:
Secure the infrastructure client / server instances

#### Stack :

--> Objective is to build a simple configuration on top of playbook-vps sub playbooks to provide container orchestration and envs (staging / prod) for apps

TO DO
------------
- vault
- consul & nomad server on heroku container
- list a test host file
- Create consul cluster before vault and unidirectional connect
- Secure nomad with vault
- Configure security role

**Less emergency**

- Nomad Simple container management system
- UI to manage deployments between different environments => auto CI deploy template
- Vault system with dynamic secret and project protection
- Vault CA Authority
- Make app playbook template with nomad job
- split app logs

Roles used by sub-playbook:
------------

### Debug

To test these playbooks we need to use makefile with multiple commands available by tiping `make`
To add debug on a playbook you need to fill `dev_hosts` in `inventories/`

### Env :

- **role-basics** with deps : ansible-role-zsh & weareinteractive.users

### Security :

- role-firewall (jeff g.)
- role-security (jeff g.)

### Monitoring

- need `requirements.txt` installed
- To fix possible error `export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES`
- `brew install gnu-tar` ==> follow [this answer](https://stackoverflow.com/a/54760575/11132253)

```bash
echo -e 'export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH" \nexport MANPATH="/usr/local/opt/gnu-tar/libexec/gnuman:$MANPATH" ' >> ~/.bashrc
```

### Stack :

Later it's can be more logical to split server in two nodes with a master custer and client one

> Check requirements

- role-docker
- role-nomad &rarr; https://github.com/ansible-community/ansible-nomad
- role-traefik &rarr; https://github.com/kibatic/ansible-traefik
- role-vault &rarr; https://github.com/ansible-community/ansible-vault
- role-consul &rarr; https://github.com/ansible-community/ansible-consul
- role-logrotate

**How hashicorp tools are ordered**

> Every hashitool is a dependancy for a next one

1. Consul : First Always build leader (bootstrap) consul container, it connect everything together
1. Vault : Allow to enable ACL in nomad
1. Nomad : Server to manage  client deployers

To build use `make (consul|vault|nomad).docker-run`

To test these tools we need to use an ansible worker, create it with `make aw`
Next you can alias usage with for example `alias wk='docker exec ansible-worker'`

### Vault :

Vault instance is hosted on heroku container

1. `heroku container:login`
1. `PUB=$(cat ~/.ssh/id_rsa.pub) heroku container:push vault -a acl-vault`
1. `heroku container:release -a acl-vault`

### Secure user creation

1. `htpasswd -nb vagrant toto`
1.  Open `ansible-vault edit inventories/vps/group_vars/all/secrets`
1. `user1.password: $apr1$4mjrgol9$toKJeYzjKhS3qcWJl8Tvb`

Requirements
------------

`make` give an help

`make install`

`make site ANSIBLE_VARS=ansible_user=root`

See [Makefile](Makefile) for debugging and full deploy on a server

License
-------

BSD 3

Author Information
------------------

[Loic Roux](https://github.com/loic-roux-404)

Credits
-------
[marcolancini](https://www.marcolancini.it/2019/blog-offensive-infrastructure-hashistack/)
