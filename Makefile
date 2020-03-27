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
	
test:
	ansible all.yml -i ./inventories/test/ env 