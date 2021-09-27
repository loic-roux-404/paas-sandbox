#!/usr/bin/env bash

# Tests packer build all machines
# - Target : linux
# ========
# Required
# - packer
# - libguestfs
# - env : VAGRANT_CLOUD_TOKEN

set -u -o pipefail -c

# Core variables
BUILDER="builder.hcl"
DISTRO="${1}"
BOX_VERSION="${2}"
BOX_VAGRANT_CLOUD_TAG="${3:-loic-roux-404/$DISTRO}"
# Utils
TEE='|& ts |& tee -ai $*.log' # log every command

requirements() {

    if [ -n "$BOX_VERSION" ]; then
        echo '[ Required box version in second arg, ex: 0.1.0 ]'
        exit 1
    fi

    if [ -n "$DISTRO" ]; then
        echo '[ Required distro version in second arg ]'
        printf "Available : %s" "$(ls vars)"
        exit 1
    fi

    sudo apt update
    sudo apt install -y moreutils \
        unzip curl jq zsh \
        libguestfs-tools
}

build() {
    packer build\
        -parallel-builds=1 \
        -var box_version="$BOX_VERSION" \
        -var box_tag="$BOX_VAGRANT_CLOUD_TAG" \
        -var-file "vars/$DISTRO.hcl" \
        -force "$BUILDER" "$TEE"
}

tests() {
    echo "[ Tests passed successfully ]"
}

clean() {
    if [ -n "$SKIP_CLEAN" ]; then
        echo "[ Cleaning all artifacts ]"

        rm "*.build/*"
        rm -rf "*.build/"
        rm "*.vmdk"
        rm "*.ovf"
        rm "*.qcow2"
        rm "*.img"
        rm box.in/*.img
    fi
}

requirements
build
tests
clean
