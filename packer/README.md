
# Vanilla Debian Packer templates

# TODO:
- [ ] Add playbook-vps (add netstat in commands)
- [ ] Create a docker image builder
- [ ] DRY box compress and upload script to vagrant-cloud
- [ ] Fix libguestfs support on mac Os + doc if good
- [ ] Add Ubuntu focal 20 + Ubunutu 19 ?
- [ ] Auto CHANGELOG and versionning
- [ ] Create LXC (need linux temp vm)
- [ ] Run github action if folder edited in commit

# Documentation
see https://app.vagrantup.com/debian

## Directory Structure
If you had some templates here please follow the following directory
structure: buildername-virtualizationbackend-extrainfo

See https://wiki.debian.org/Teams/Cloud/VagrantBaseBoxes for Vagrant with Virtualbox

# Credits

The templates here are uploaded to https://app.vagrantup.com/loic-roux-404/

Author Information
------------------

[Loic Roux](https://github.com/loic-roux-404)

[Mitchell Hashimoto](https://github.com/mitchellh/) for his awesome work on [Packer](https://github.com/mitchellh/packer) and [Vagrant](https://github.com/mitchellh/vagrant)
[Emmanuel Kasper](https://github.com/EmmanuelKasper) &rarr; https://github.com/EmmanuelKasper/import2vbox
