# Base makefile for ansible / vagrant projects
SHELL=/bin/bash
# read setting from config
config=$(shell yq merge -x .manala.yaml config.yaml | yq r - $(1))
# All variables necessary to run and debug ansible playbooks
PLAYBOOKS=$(basename $(wildcard *.yml))
DEFAULT_PLAYBOOK=$(basename $(call config,vagrant.ansible.sub_playbook))
IP?=$(call config,vagrant.network.ip)
DOMAIN?=$(call config,vagrant.domain)
# ansible vars
ANSIBLE_VARS:=$(shell echo -n $(call config,vagrant.ansible.vars) |\sed -e 's/:[^:\/\/]/="/g;s/$$/"/g;s/ *=/=/g')
OPTIONS:=$(foreach var, $(ANSIBLE_VARS), -e $(subst ",,$(var)))
# Environment variables of ansible
ANSIBLE_STDOUT_CALLBACK:=default
ANSIBLE_FORCE_COLOR:=true
# Default Inventory
INVENTORY?=$(call config,ansible.inventory)
DEV_INVENTORY:=$(call config,ansible.inventory)/dev_hosts
HOST:=
ROLES:=$(notdir $(basename $(wildcard roles/role-*) ))
TAGS+=$(ROLES)
# Debug command list
INVS_DEBUG:=graph list

# Build command
playbook_exe= ANSIBLE_STDOUT_CALLBACK=$(ANSIBLE_STDOUT_CALLBACK) \
	ANSIBLE_FORCE_COLOR=$(ANSIBLE_FORCE_COLOR) \
	ansible-playbook $(OPTIONS) \
	$(if $(INVENTORY), \
		-i $(INVENTORY)$(if $(HOST),$(HOST),) \
	,) \
	$(if $(1),$(1).yml,$*.yml) $(ARG)
# Prompt exe
prompt?=echo -ne "\x1b[33m $(1) Sure ? [y/N]\x1b[m" && read ans && [ $${ans:-N} = y ]

help:
	@echo "[======== Ansible Help ========]"
	@echo "Usage: make <playbook> (ARG=<your-arg>)"
	@echo "Available PLAYBOOKS: $(PLAYBOOKS)"
	@echo "run role / tag : $(addsuffix .tag, $(TAGS)))"
	@$(MAKE) help_more || echo -n ''
	@echo "[========== OPTIONS ===========]"
	@echo "Extra vars : $(ANSIBLE_VARS)"
	@echo "Ip: $(IP)"
	@echo "Domain: $(DOMAIN)"
	@echo "default inventory: $(INVENTORY)"
	@echo "[====== DEBUG COMMANDS ========]"
	@echo "Debug playbook (vagrant) : $(addsuffix .debug, $(PLAYBOOKS))"
	@echo "Debug inventory vars : $(addsuffix .invs, $(INVS_DEBUG))"
	@echo "[==============================]"

.DEFAULT_GOAL := help
.PHONY: $(PLAYBOOKS)
.PRECIOUS: %.run
$(PLAYBOOKS): % : %.run

install:
	ansible-galaxy install -r roles/requirements.yml $(ARG)
	$(foreach var,$(shell ls -d *roles/role*/requirements.txt),pip install -r $(var))
	$(foreach var,$(shell ls -d *.ext_roles/role*/requirements.txt),pip install -r $(var))

# ==============================
# Warning run target is for prod
# ==============================
%.run:
	@$(call prompt)
	@$(call playbook_exe)

# avoid prompt (Use this in automated processes)
%.run-f:
	@$(call playbook_exe)

# Run specific tag / role name
# Example : make basics.tag ( for role-basics)
# Role are automaticly tagged with ansible callback plugin auto_tag.py
%.role: debug-deco
	$(eval ARG:='--tag=role-$*')
	$(call playbook_exe, $(DEFAULT_PLAYBOOK))

%.tag: debug-deco
	$(eval ARG:='--tag=$*')
	$(call playbook_exe, $(DEFAULT_PLAYBOOK))

# =============================
# Debugging zone on next lines
# =============================
debug-deco:
	$(eval ANSIBLE_STDOUT_CALLBACK:=yaml)
	$(eval INVENTORY:=$(DEV_INVENTORY))

%.debug: debug-deco
	$(call playbook_exe)

%.invs:
	ansible-inventory -i $(INVENTORY) --$* $(ARG)
