export VAGRANT_DEFAULT_PROVIDER = virtualbox

SHELL = /bin/zsh # needed for |&
# exit on undefined variables, pipeline fails if one command fails
.SHELLFLAGS = -u -o pipefail -c
TEE = |& ts |& tee -ai $*.log # log every command
ISO_DATE_SEMVER = $(shell date +%Y.%m.%d)
# Box
CHANGELOG?= "* stable point release"
BOX_VERSION?=0.0.0
VAGRANT_CLOUD_TOKEN?=$(shell cat .token)
# Options
EXT:=json#pkr.hcl
DISTRIBUTIONS= $(basename $(wildcard *.$(EXT)))
BUILDERS:=vbox qemu
# Packer vars (default to debian)
DISTRO_NAME?=debian
VAGRANT_CLOUD_TAG?=loic-roux-404/deb64-buster
DIS_VERSION?=10.7
SHA_URL?=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS
DIS_SHA256?=curl $(SHA_URL) |\
 	grep '$(DISTRO_NAME).($(DIS_VERSION)).*amd64.*netinst'
# Create build vars
BUILD_VARS:= -var box_version='$(BOX_VERSION)' $(BUILD_VARS) \
	-var DIS_SHA256

all:
	@echo "Usage: make <distribution>.<options>.<suboptions>"
	@echo "Available distributions: $(DISTRIBUTIONS)"
	@echo "Available options: <distribution>.debug <distribution>.test"
	@echo "suboptions per builder: <distribution>.debug.qemu"

.PHONY: $(DISTRIBUTIONS)
.PRECIOUS: %.build

$(DISTRIBUTIONS): % : %.build


%.build: clean
	$(eval BUILD_VARS:= -var box_version='$(BOX_VERSION)' $(BUILD_VARS))
	-$(RM) $*.log
	#-var-file="vars/$*.hcl"
	packer build\
		-parallel-builds=1 $(BUILD_VARS) \
		$(ONLY)\
		-force $*.$(EXT) $(TEE)

soft_clean:
	-$(RM) *.build/*
	-rm -rf *.build/

clean:: soft_clean
	@echo "Cleaning all artifacts"
	-$(RM) *.vmdk
	-$(RM) *.ovf
	-$(RM) *.qcow2
	-$(RM) *.img
	-$(RM) box.in/*.img

full_clean: soft_clean clean
	@echo "temp VM and artifact boxes"
	-rm -rf *.export/
	vagrant destroy -f

%.convert:
	@echo "You need vmdk file before using this target"
	VM_NAME=$* OUTPUT=$*.build vagrant up --provision
	scp -P 2222 vagrant@localhost:/home/vagrant/buster.ovf ./

%.debug: soft_clean
	$(eval distro := $(subst .debug,,$*))
	-$(RM) $(distro).log
	#-var-file="vars/$*.hcl"
	PACKER_LOG=1 packer build \
		-debug \
		-on-error=ask \
		-force  \
		 $(distro).$(EXT) $(TEE)

%.debug.qemu: soft_clean
	$(eval distro := $(subst .debug.qemu,,$*))
	-$(RM) $(distro).log
	#-var-file="vars/$*.hcl"
	PACKER_LOG=1 packer build \
		-debug \
		-on-error=ask \
		-force \
		-only=qemu \
		$(distro).$(EXT) $(TEE)

%.debug.vbox: soft_clean
	$(eval distro := $(subst .debug.qemu,,$*))
	-$(RM) $(distro).log
	PACKER_LOG=1 packer build \
		-var-file="vars/$*.hcl"\
		-debug \
		-on-error=ask \ 
		-force \
		-only=virtualbox-ovf \
		$(distro).$(EXT) $(TEE)

# Temporary workaround waiting for github solution or packer fix
%.libvirt.box:
	@echo "Creating file : " $@
	rm -rf ../$*.build/exports/$@
	mkdir -p $*.build/exports/
	mv $*.img box.in/box.img
	cd box.in && tar czvf ../$*.build/exports/$@ metadata.json box.img Vagrantfile

# test virtual machines
include ../helpers/vagrant-test-targets.mk
