include .settings/mk/ansible-commons.mk

help_more:
	@echo "Fake deploy on vps: $(addsuffix .test.vps, $(PLAYBOOKS))"

# =============================
# Debugging zone on next lines
# =============================
OPTIONS:= $(OPTIONS)\
	-e ansible_host=$(DOMAIN)\
	-e ansible_port=22\
	-e ansible_user=vagrant\

debug: 
	$(eval ANSIBLE_STDOUT_CALLBACK:=yaml)
	@$(MAKE) running DEBUG='IN DEBUG MODE '

%.test.vps: debug
	$(eval OPTIONS:=$(OPTIONS) \
		-e domain_test=$(DOMAIN) \
		-e base_ipv4=$(IP)\
	)
	@$(call playbook_exe)

%.test.local: debug
	$(eval INVENTORY:=local)
	@$(call playbook_exe)
