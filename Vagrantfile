# -*- mode: ruby -*-
# vi: set ft=ruby :

# TEST playbook `Vagrantfile`
# mac workaround
SOCKET = File.join(Dir.home, ".cache/libvirt/libvirt-sock") 

Vagrant.configure('2') do |config|
  config.vm.define :test_vm do |test_vm|
    test_vm.vm.box = "debian/buster64"
  end

  # use nfsv4 mode by default since rpcbind is not available on startup
  # we need to force tcp because udp is not availaible for nfsv4
  #config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_version: "4", nfs_udp: false

  # use rsync to test playbook
  config.vm.synced_folder '.', '/vagrant',type:'rsync', rsync__auto: true,
  rsync__args: ["--archive", "--delete", "--no-owner", "--no-group","-q"]

  # Options for libvirt vagrant provider.
  config.vm.provider :libvirt do |libvirt|

    # A hypervisor name to access. Different drivers can be specified, but
    # this version of provider creates KVM machines only. Some examples of
    # drivers are kvm (qemu hardware accelerated), qemu (qemu emulated),
    # xen (Xen hypervisor), lxc (Linux Containers),
    # esx (VMware ESX), vmwarews (VMware Workstation) and more. Refer to
    # documentation for available drivers (http://libvirt.org/drivers.html).
    libvirt.driver = 'qemu'
    libvirt.socket = SOCKET
    #libvirt.uri = 'qemu:///'

    # The name of the server, where libvirtd is running.
    libvirt.host = "localhost"

    # If use ssh tunnel to connect to Libvirt.
    libvirt.connect_via_ssh = false

    # The username and password to access Libvirt. Password is not used when
    # connecting via ssh.
    libvirt.username = 'root'
    #libvirt.password = "secret"

    # Libvirt storage pool name, where box image and instance snapshots will
    # be stored.
    libvirt.storage_pool_name = 'default'

    # Set a prefix for the machines that's different than the project dir name.
    #libvirt.default_prefix = ''
  end
end
