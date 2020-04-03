PLAYBOOKS = $(basename $(wildcard *.yml))
verbose=
role=
ask-vault=

all:
	@echo "Usage: make <playbook> (role='role-yours') (verbose='-v')"
	@echo "Available PLAYBOOKS: $(PLAYBOOKS)"
	@echo "Fake deploy on vps: $(addsuffix .test.vps, $(PLAYBOOKS))"

install:
	ansible-galaxy install -r roles/requirements.yml

.PHONY: $(PLAYBOOKS)
.PRECIOUS: %.run
$(PLAYBOOKS): % : %.run

# default to vps in makefile
%.run: 
	ansible-playbook -i ./inventories/vps/ $*.yml $(verbose)

# role option take --tag your-role as option
# verbose write simply verbose="-vvv"
# --ask-vault-pass
%.test.vps: 
	ansible-playbook -e ansible_host=localhost \
	-e ansible_port=2222 \
	-e ansible_user=vagrant \
	-e domain=loicroux.com \
	-i ./inventories/vps/ $*.yml $(verbose) $(role)

%.test.local:
	ansible-playbook -e ansible_host=localhost \
	-e ansible_port=2222 \
	-e ansible_user=vagrant \
	-i ./inventories/local/ $*.yml $(verbose) $(role)
