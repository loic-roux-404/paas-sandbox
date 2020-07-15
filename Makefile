include .manala/ansible.mk
include .manala/docker.mk

DOCKER_IMG_PREFIX:=404-infra
DOCKER_CONTEXT:=./docker
DOCKER_IMAGES:=$(notdir $(basename $(wildcard docker/*.Dockerfile)))
HEROKU_APP_NAME:=$(DOCKER_IMG_PREFIX)
DOCKER_NETWORK:=stack
# Container exposed ports
vault.ports:= -p $(DSP).2:22222:22 -p 8200:8200
consul.ports:= -p $(DSP).3:222:22 -p 8600:8600 -p 8300-8302:8300-8302 -p 8500:8500
nomad.ports:= -p $(DSP).4:2022:22 -p 4646:4646 -p 4647:4647 -p 4648:4648 -p 4648:4648

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
	$(eval PORTS:=$($*.ports))
	$(eval IP:=$($*.ip))
	$(eval DOCKERFILE:=docker/$*.Dockerfile)
	$(call docker_run)

# Deploy container as an heroku dyno
deploy:
	$(eval export PASS=$(shell utils/vault_pass.sh))
	cd docker \
	&& heroku container:push --recursive -a $(HEROKU_APP_NAME)
