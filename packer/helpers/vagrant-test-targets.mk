TEST_DIR = test
MK_PWD:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

%.test.virtualbox:
	$(eval provider:=virtualbox)
	$(eval distro:=$(subst .test.$(provider),,$*))
	$(MK_PWD)vagrant-test $(provider)\
		$(distro)\
		$(CURDIR)/$(distro).build/exports/$(distro).$(provider).box

%.test.qemu:
	$(eval provider:=qemu)
	$(eval distro:=$(subst .test.$(provider),,$*))
	$(MK_PWD)/vagrant-test "libvirt" $(distro) $(CURDIR)/$(distro)

%.test.destroy:
	$(eval distro := $(subst .test.destroy,,$*))
	cd $(MK_PWD)/$*-$(TEST_DIR) ; \
	export VM_NAME=$(distro); \
	vagrant destroy -f || true
	rm -rf $(MK_PWD)/$*-$(TEST_DIR)
