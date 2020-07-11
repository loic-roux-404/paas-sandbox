include .manala/ansible.mk

VAULT_IMAGE_TAG:=404-infra/vault
VAULT_APP_NAME:=acl-vault

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

%.vault-test:
	$(eval INVENTORY?=./inventories/vps)
	$(eval OPTIONS+= \
		-e ansible_host=localhost \
		-e ansible_user=root \
		-e ansible_port=22222 \
	)
	$(eval HOST:=,vault_instances) # Always use comma for python tuple parsing
	$(call playbook_exe)

# -e vault_address=localhost
# -e vault_port=8200
# -e vault_cluster_address=localhost:8200
# -e vault_cluster_addr=http://localhost:8200
# -e vault_api_addr=http://localhost:8200

first-run:
	$(MAKE) site ANSIBLE_VARS=ansible_user=root

docker-vault-test:
	export PUB=$$(cat ~/.ssh/id_rsa.pub) \
	ID=$$( \
		docker -l debug build \
 		--build-arg PUB \
 		-t=$(VAULT_IMAGE_TAG):latest\
		docker/vault \
	) && docker run -p 8200:8200 -p 22222:22 \
		--rm \
		-it \
		-d $(VAULT_IMAGE_TAG) \
		&& echo "image_$${ID}"

deploy-vault:
	cd docker/vault
	heroku container:push --recursive -a $(VAULT_APP_NAME)
