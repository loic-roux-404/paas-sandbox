PLAYBOOKS = $(basename $(wildcard *.yml))

all:
	@echo "Usage: make <playbook>"
	@echo "Available PLAYBOOKS: $(PLAYBOOKS)"

.PHONY: $(PLAYBOOKS)
.PRECIOUS: %.run
$(PLAYBOOKS): % : %.run

%.run: 
	ansible-playbook $*.yml

%.vault:	
	ansible-playbook $*.yml --vault-password-file
	
%.test.deploy:
	ansible-playbook -e ansible_host=localhost \
	-e ansible_port=2222 \
	-e ansible_user=vagrant \
	 -i ./inventories/deploy/ $*.yml

install:
	ansible-galaxy install -r roles/requirements.yml