include .manala/ansible.mk

VAULT_IMAGE_TAG:=404-infra/vault

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

docker-vault-test:
	ID=$$( \
		docker build \
			--quiet \
			-t=$(VAULT_IMAGE_TAG):latest\
			files/vault \
	) && docker run -p 8200:8200 \
		--rm \
		-it \
		-d $(VAULT_IMAGE_TAG) \
		&& echo "image_$${ID}"
