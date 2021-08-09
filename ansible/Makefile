include .manala/ansible.mk
include .manala/docker.mk

DOCKER_IMG_PREFIX:=404-infra
DOCKER_CONTEXT:=./docker
DOCKER_IMAGES:=$(notdir $(basename $(wildcard docker/*.Dockerfile)))
HEROKU_APP_NAME:=$(DOCKER_IMG_PREFIX)
# Container exposed ports
vault.ports:= -p 22222:22 -p 8200:8200
# Container ip on subnet
DOCKER_NETWORK:=stack
# suffixes for ips
aw.ip=2
vault.ip=3

help_more:
	@echo "Docker service : $(addsuffix .docker, $(DOCKER_IMAGES)))"

# =============================
# Additionals playbook commands
# =============================

%.debug.packer: debug-deco
	$(eval INVENTORY:=./inventories/packer)
	$(call playbook_exe)

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

all_docker: ansible-worker.docker vault.docker

# Deploy container as an heroku dyno
deploy:
	$(eval export PASS=$(shell utils/vault_pass.sh))
	cd docker \
	&& heroku container:push --recursive -a $(HEROKU_APP_NAME)

