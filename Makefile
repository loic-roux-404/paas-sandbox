include .manala/ansible.mk
include .manala/docker.mk

DOCKER_IMG_PREFIX:=404-infra
DOCKER_CONTEXT:=./docker
DOCKER_IMAGES:=$(notdir $(basename $(wildcard docker/*.Dockerfile)))
HEROKU_APP_NAME:=$(DOCKER_IMG_PREFIX)
# Container exposed ports
vault.ports:= -p 22222:22 -p 8200:8200
consul.ports:= -p 222:22 -p 8600:8600 -p 8300-8302:8300-8302 -p 8500:8500
nomad.ports:= -p 2022:22 -p 4646:4646 -p 4647:4647 -p 4648:4648 -p 4648:4648
# Container ip on subnet
DOCKER_NETWORK:=stack
consul.ip=2
vault.ip=3
nomad.ip=4

help_more:
	@echo "Docker service : $(addsuffix .docker, $(DOCKER_IMAGES)))"

# =============================
# Additionals playbook-vps commands
# =============================
%.debug.local: debug-deco
	$(eval INVENTORY:=./inventories/local)
	$(call playbook_exe)

# Debug stack playbook on containers
# Usage : make (vault|nomad|consul).tag
%.tag.stack:
	$(eval OPTIONS+= -e ansible_user=$*)
	$(eval OPTIONS+= -e ansible_password=$*)
	$(MAKE) $*.tag

# ======================
# Docker services
# ======================
# put ssh key in these containers
export PUB=$(shell cat ~/.ssh/id_rsa.pub)
export PRIV=$(shell cat ~/.ssh/id_rsa)

# Test container deploys
%.docker:
	$(eval export USER=$*)
	$(eval IMAGE_TAG:=$(DOCKER_IMG_PREFIX)/$*)
	$(eval DOCKER_ARGS:=PUB)
	$(eval DOCKER_ENVS:=-e PUB=)
	$(eval PORTS:=$($*.ports))
	$(eval NET:=$($*.ip))
	$(eval DOCKERFILE:=docker/$*.Dockerfile)
	$(call docker_run)

# docker ansible worker
aw.docker:
	$(eval IMAGE_TAG:=aw)
	$(eval DOCKER_ARGS:=-e PRIV)
	$(eval DOCKER_ENVS:=-e PRIV=)
	$(eval VOLUMES:=-v $(PWD):/playbook)
	$(eval DOCKERFILE:=docker/aw.Dockerfile)
	$(call docker_run)

all_docker: aw.docker consul.docker vault.docker nomad.docker

# Deploy container as an heroku dyno
deploy:
	$(eval export PASS=$(shell utils/vault_pass.sh))
	cd docker \
	&& heroku container:push --recursive -a $(HEROKU_APP_NAME)

symlinks:
	ln -s ${HOME}/Ops/ansible/role-traefik/ (pwd)/roles/role-traefik
	ln -s ${HOME}/Ops/ansible/role-dns/ (pwd)/roles/role-dns
	ln -s ${HOME}/Ops/ansible/role-basics/ (pwd)/roles.role-basics
