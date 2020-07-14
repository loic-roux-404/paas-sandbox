include .manala/ansible.mk
include .manala/docker.mk

DOCKER_IMG_PREFIX:=404-infra
DOCKER_CONTEXT:=./docker
DOCKER_IMAGES:=$(notdir $(basename $(wildcard docker/*.Dockerfile)))
HEROKU_APP_NAME:=$(DOCKER_IMG_PREFIX)
vault.sshPort:=22222
consul.sshPort:=2222
nomad.sshPort:=2022

help_more:
	@echo "Fake deploy on vps : $(addsuffix .debug.vps, $(PLAYBOOKS))"
	@echo "Docker service : $(addsuffix .docker-run, $(DOCKER_IMAGES)))"

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

# Test container deploys
%.docker-run:
	$(eval export USER=$*)
	$(eval IMAGE_TAG:=$(DOCKER_IMG_PREFIX)/$*)
	$(eval PORTS:=-p $($*.sshPort):22 -p 8300-8600:8300-8600)
	$(eval DOCKERFILE:=docker/$*.Dockerfile)
	$(call docker_run)

# Deploy container as an heroku dyno
deploy:
	$(eval export PASS=$(shell utils/vault_pass.sh))
	cd docker \
	&& heroku container:push --recursive -a $(HEROKU_APP_NAME)
