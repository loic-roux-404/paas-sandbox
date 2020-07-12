include .manala/ansible.mk

VAULT_IMAGE_TAG:=404-infra/vault
VAULT_APP_NAME:=acl-vault

help_more:
	@echo "Fake deploy on vps: $(addsuffix .debug.vps, $(PLAYBOOKS))"

# =============================
# Additionals playbook-vps commands
# =============================

%.debug.vps: debug-deco
	$(eval OPTIONS+= -e ansible_user=vagrant)
	$(call playbook_exe)

%.debug.local: debug-deco
	$(eval INVENTORY:=./inventories/local)
	$(call playbook_exe)

%.debug-vault: debug-deco
	$(eval ARG:='--tag=role-vault')
	$(call playbook_exe)

docker-vault-test:
	export PUB=$$(cat ~/.ssh/id_rsa.pub) \
	ID=$$( \
		docker -l debug build \
 		--build-arg PUB \
 		-t=$(VAULT_IMAGE_TAG):latest\
		docker/vault \
	) && docker run -p 22222:22 -p 8200:8200 \
		--rm \
		--cap-add IPC_LOCK \
		-it \
		-d $(VAULT_IMAGE_TAG) \
		&& echo "image_$${ID}"

deploy-vault:
	cd docker/vault
	heroku container:push --recursive -a $(VAULT_APP_NAME)
