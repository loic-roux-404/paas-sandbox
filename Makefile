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

%.run: 
	ansible-playbook $*.yml

# role option take --tag your-role as option
# verbose write simply verbose="-vvv"
# --ask-vault-pass
%.test.deploy: 
	ansible-playbook -e ansible_host=localhost \
	-e ansible_port=2222 \
	-e ansible_user=vagrant \
	-i ./inventories/deploy/ $*.yml $(verbose) $(role)

install:
	ansible-galaxy install -r roles/requirements.yml
