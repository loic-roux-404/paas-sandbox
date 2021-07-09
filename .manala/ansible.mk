# Base makefile for ansible / vagrant projects
SHELL=/bin/bash
# Executables
PIP:=pip3

# Functions
# read setting from config (touch config.yaml if not exist)
config=$(shell yq -xa merge config.yaml .manala.yaml | yq r - $(1))

define parse_ansible_vars
	$(foreach var, $1, -e $(subst ",,$(var)))
endef

define parse_ansible_tags
	$(foreach var, $1, -t $(subst ",,$(var)))
endef

# All variables necessary to run and debug ansible playbooks
PLAYBOOKS=$(basename $(wildcard *.yml))
DEFAULT_PLAYBOOK=$(basename $(call config,vagrant.ansible.sub_playbook))
IP?=$(call config,vagrant.network.ip)
DOMAIN?=$(call config,vagrant.domain)
# ansible vars
OPTIONS:=$(call parse_ansible_vars, $(ANSIBLE_VARS))
# Environment variables of ansible
ANSIBLE_STDOUT_CALLBACK:=default
ANSIBLE_FORCE_COLOR:=true
ANSIBLE_BECOME_METHOD:=
# Default Inventory
INVENTORY?=$(call config,ansible.inventory)
HOST:=
ROLES:=$(notdir $(basename $(wildcard roles/role-*) ))
TAGS+=$(ROLES) # Need callback plugin
# Debug command list
INVS_DEBUG:=graph list

# Build command
define playbook_exe
	$(if $(ANSIBLE_BECOME_METHOD),ANSIBLE_BECOME_METHOD=$(ANSIBLE_BECOME_METHOD),) \
	ANSIBLE_STDOUT_CALLBACK=$(ANSIBLE_STDOUT_CALLBACK) \
	ANSIBLE_FORCE_COLOR=$(ANSIBLE_FORCE_COLOR) \
	ansible-playbook $(OPTIONS) \
	$(call parse_ansible_tags, $(TAG)) \
	$(if $(INVENTORY),-i $(INVENTORY)$(or $(HOST),),) \
	$(if $1,$1.yml,$*.yml) \
	$(ARG)
endef
# Prompt exe
define prompt
	echo -ne "\x1b[33m $1 Sure ? [y/N]\x1b[m" && read ans && [ $${ans:-N} = y ]
endef

help:
	@echo "[======== Ansible Help ========]"
	@echo "Usage: make <playbook> (ARG=<your-arg>)"
	@echo "run role / tag : $(addsuffix .tag, $(TAGS))"
	@echo "add .debug to debug tag in local vm"
	@echo "Available PLAYBOOKS: $(PLAYBOOKS)"
	@$(MAKE) help_more || echo -n ''
	@echo "[========== OPTIONS ===========]"
	@echo "Ip: $(IP)"
	@echo "Domain: $(DOMAIN)"
	@echo "default inventory: $(INVENTORY)"
	@echo "default playbook: $(DEFAULT_PLAYBOOK)"
	@echo "[====== DEBUG COMMANDS ========]"
	@echo "playbook (vagrant) : $(addsuffix .debug, $(PLAYBOOKS))"
	@echo "inventory hosts : $(addsuffix .invs, $(INVS_DEBUG))"
	@echo "host vars : inventory-hostname.facts"
	@echo "[==============================]"

.DEFAULT_GOAL := help
.PHONY: $(PLAYBOOKS)
.PRECIOUS: %.run
$(PLAYBOOKS): % : %.run

install:
	ansible-galaxy install -r requirements.yaml $(ARG)
	$(PIP) install -r requirements.txt || true
	$(foreach var,$(shell ls -d *roles/role*/requirements.txt),$(PIP) install -r $(var))
	$(foreach var,$(shell ls -d *.ext_roles/role*/requirements.txt),$(PIP) install -r $(var))

# ==============================
# Warning run target is for prod
# ==============================
%.run:
	@$(call prompt)
	@$(call playbook_exe)
# avoid prompt (Use this in automated processes)
%.run-f:
	@$(call playbook_exe)

.PHONY: $(addsuffix .tag, $(TAGS))
# Run specific tag / role name
# Example : make role-basics.tag ( for role-basics)
# Role are automaticly tagged with ansible callback plugin auto_tag.py
%.tag:
	$(eval TAG:=$*)
	$(call playbook_exe, $(DEFAULT_PLAYBOOK))

%.tag.debug: debug-deco
	$(eval TAG:=$*)
	$(call playbook_exe, $(DEFAULT_PLAYBOOK))

# =============================
# Debugging zone on next lines
# =============================
debug-deco:
	$(eval ANSIBLE_BECOME_METHOD:=sudo)
	$(eval ANSIBLE_STDOUT_CALLBACK:=yaml)
	$(eval OPTIONS+=\
		$(call parse_ansible_vars, ansible_user=vagrant ansible_host=localhost))

.PRECIOUS: $(addsuffix .invs, $(PLAYBOOKS))
# Launch playbook in debug mode : formatted yaml &
# dev inventory pointing to docker hosts
%.debug: debug-deco
	$(call playbook_exe)

.PRECIOUS: $(addsuffix .debug, graph list)
# More info about playbook env : graph.invs list.invs
%.invs:
	ansible-inventory -i $(INVENTORY) --$* $(ARG)

.PRECIOUS: hostname-from-inventory.facts
%.facts:
	ansible -i $(INVENTORY) $* -m setup
