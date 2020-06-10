include .manala/ansible.mk

help_more:
	@echo "Fake deploy on vps: $(addsuffix .debug.vps, $(PLAYBOOKS))"

# =============================
# Additionals playbook-vps commands
# =============================

%.debug.vps: debug-deco
	$(eval INVENTORY?=./inventories/vps)
	$(call playbook_exe)

%.debug.local: debug-deco
	$(eval INVENTORY:=./inventories/local)
	$(call playbook_exe)

first-run:
	$(MAKE) site ANSIBLE_VARS=ansible_user=root
