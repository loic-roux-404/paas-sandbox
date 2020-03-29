# -*- mode: ruby -*-
# vi: set ft=ruby :

if !Vagrant.has_plugin?('vagrant-vbguest')
  system('vagrant plugin install vagrant-vbguest')
end

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
playbook_name = ENV['PLAYBOOK'] ? ENV['PLAYBOOK']  : 'site.yaml'

Vagrant.configure("2") do |config|
    config.vm.box = "loic-roux-404/deb64-buster"
    config.vm.box_check_update = false
    # enablle if you want shared folders
    config.vbguest.auto_update = false

    id_rsa_path        = File.join(Dir.home, ".ssh", "id_rsa")
    id_rsa_ssh_key     = File.read(id_rsa_path)
    id_rsa_ssh_key_pub = File.read(File.join(Dir.home, ".ssh", "id_rsa.pub"))
    insecure_key_path  = File.join(Dir.home, ".vagrant.d", "insecure_private_key")
  
    config.ssh.insert_key = false
    config.ssh.forward_agent = true
    config.ssh.private_key_path = [id_rsa_path, insecure_key_path]

    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--name", "playbook_vps_debug"]
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end

    config.vm.network :forwarded_port, id: "ssh", guest: 22, host: 2222

    config.vm.synced_folder ".", "/vagrant", type: 'rsync', rsync__auto:true,
      rsync__args: ["--archive", "--delete", "--no-owner", "--no-group","-q", "-W"],
      rsync__exclude: [".git"]

    # config.vm.provision :shell, path: 'utils/install.sh'
    ## Install and configure software
    # config.vm.provision "ansible_local" do |ansible|
    #  ansible.provisioning_path = "#{playbook_name}/"
    #  ansible.playbook = "playbook.yml"
    #  ansible.become = true
    #  ansible.verbose = ""
    #  ansible.extra_vars = conf
    # end

    # fix ssh common issues
    ssh_path = "/home/vagrant/.ssh"
    config.vm.provision :shell, :inline => "echo '#{id_rsa_ssh_key}' > #{ssh_path}/id_rsa && chmod 600 #{ssh_path}/id_rsa"
    config.vm.provision :shell, :inline => "echo '#{id_rsa_ssh_key_pub}' > #{ssh_path}/authorized_keys && chmod 600 #{ssh_path}/authorized_keys"
  end
  
