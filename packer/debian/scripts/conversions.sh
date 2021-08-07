#!/bin/bash
# Convert qemu/kvm machine to virtualbox ovf config file
# On mac os disable sudo pass 

VMDK=$VM_NAME.vmdk
RAW=$OUTPUT/$VM_NAME
QCOW2=$VM_NAME.qcow2
OVF=$VM_NAME.ovf
V2OVF_EXE=import2vbox.pl

vdmk() {
    if [ ! -f "$VMDK" ]; then
        qemu-img convert -O vmdk $RAW $VMDK
    fi
}

# img and qcow2 are same files
qcow2() {
    if [ ! -f "$VM_NAME.img" ]; then
      qemu-img convert -p -f raw -O qcow2 $RAW $QCOW2
    fi

    mv $QCOW2 $VM_NAME.img
}

convert() {
    if [ ! -f "$OVF" ]; then
        sudo perl -MCPAN -e 'install XML::Writer'
        # retry in case of not configured CPAN 
        sudo perl -MCPAN -e 'install XML::Writer'
        sudo perl -MCPAN -e 'install UUID::Generator::PurePerl'

        cd $WORK_PATH
        sudo chmod +x $V2OVF_EXE
        echo "[ ---- Create ovf settings from vmdk file ---- ]"
        ./$V2OVF_EXE --memory 512 --vcpus 2 $VM_NAME.vmdk
    else 
        echo "Error : no vm name set on OVF variable"
    fi
}

by_vagrant_convert() {
    echo "[ ---- Use temp VM to get an ovf file ---- ]"
    vagrant up --provision || vagrant up || true
    scp -P 2222 vagrant@localhost:/home/vagrant/buster.ovf ./
    vagrant halt
    echo "[ ---- done ovf file placed on project ---- ]"
}

# run these conversions in each cases
qcow2
vdmk
fs_state

# run os specific conversions
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'

    sudo apt-get update
    sudo apt-get install -y libguestfs-tools
    convert

    ;;
  'Darwin') 
    OS='Darwin'

    # if no libguest-fs try by temporary debian machine
    if [ ! -f "$OVF" ] && ! which guestfish > /dev/null ; then
        by_vagrant_convert
    elif [ ! -f "$OVF" ]; then
        V2OVF_EXE=scripts/$V2OVF_EXE
        convert || by_vagrant_convert
    fi
    ;;

esac

fs_state() {
    echo "[[ Launch vbox disk conversions ]]"
    echo "[[ Name =: $VM_NAME ]]" 
    echo "[[ Work folder : $OUTPUT ]]"
    echo "[[ Files presents : `$(echo $VM_NAME.*)` ]]"
}