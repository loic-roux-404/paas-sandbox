PLAYBOOKS = $(basename $(wildcard *.yml))
verbose=
role=
ask-vault=

all:
	@echo "Usage: make <playbook>"
	@echo "Available PLAYBOOKS: $(PLAYBOOKS)"

.PHONY: $(PLAYBOOKS)
.PRECIOUS: %.run
$(PLAYBOOKS): % : %.run

# default to vps in makefile
%.run: 
	ansible-playbook -i ./inventories/vps/ $*.yml $(pass) $(verbose)

# role option take --tag your-role as option
# verbose write simply verbose="-vvv"
# --ask-vault-pass
%.test.deploy: 
	ansible-playbook -e ansible_host=localhost \
	-e ansible_port=2222 \
	-e ansible_user=vagrant \
	-i ./inventories/vps/ $*.yml $(verbose) $(role)

install:
	ansible-galaxy install -r roles/requirements.yml

# This command is used for first install of playbook on a vagrant instance
%.first_deploy:
	ansible-playbook -e ansible_host=localhost \
	-e ansible_user=root \
	-i ./inventories/vps/ $*.yml $(verbose) $(role)