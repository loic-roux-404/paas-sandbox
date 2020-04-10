# Makefile to run vps playbook
PLAYBOOKS=$(basename $(wildcard *.yml))
DOMAIN?=loicroux.test
# ansible-playbook arguments
OPTIONS:=
# Environment variables of ansible 
# (https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings)
ANSIBLE_STDOUT_CALLBACK?=default
# default to vps in makefile
INVENTORY?=vps
playbook_exe= \
	ANSIBLE_STDOUT_CALLBACK=$(ANSIBLE_STDOUT_CALLBACK) \
	ansible-playbook $(OPTIONS) \
	-i ./inventories/$(INVENTORY) $*.yml $(ARG)


help:
	@echo "Usage: make <playbook> (ARG=<your-arg>)"
	@echo "Available PLAYBOOKS: $(PLAYBOOKS)"
	@echo "Fake deploy on vps: $(addsuffix .test.vps, $(PLAYBOOKS))"

.DEFAULT_GOAL := help
.PHONY: $(PLAYBOOKS)
.PRECIOUS: %.run
$(PLAYBOOKS): % : %.run

install:
	ansible-galaxy install -r roles/requirements.yml $(ARG)
	pip install -r roles/requirements.txt

%.run: 
	@$(call playbook_exe)

# Entering debugging zone on next lines
OPTIONS:= -e ansible_host=localhost \
	-e ansible_port=2222 \
	-e ansible_user=vagrant \

debug: 
	$(eval ANSIBLE_STDOUT_CALLBACK:=debug)

%.test.vps: debug
	$(eval OPTIONS:=$(OPTIONS) \
		-e domain_test=$(DOMAIN) \
		-e network_default_ipv4=192.168.33.10 \
		-e network_default_ipv6=2a01:e35:2e89:6130:ca5:2cd6:c199:1c3a \
	)
	@echo "RUNNING : "${playbook_exe}
	@$(call playbook_exe)

%.test.local: debug
	$(eval INVENTORY:=local)
	@echo "RUNNING : "${playbook_exe}
	@$(call playbook_exe)
