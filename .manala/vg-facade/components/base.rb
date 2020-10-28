# Base box init component
class Base < Component
	DEFAULT_BOX = "loic-roux-404/deb64-buster"

	def initialize(cnf)
		@UPDATE_VBGUEST = ENV['VBGUEST_UPDATE'] || cnf.vb_guest_update
		@UPDATE_BOX = ENV['BOX_UPDATE'] || cnf.box_update
		super(cnf)

		self.dispatch_all
	end

	def base_box()
		$vagrant.vm.hostname = @cnf.domain
		$vagrant.vm.box = @cnf.box || DEFAULT_BOX
		@cnf.box_version ? $vagrant.vm.box_version = @cnf.box_version : nil
    	$vagrant.vm.box_check_update = @UPDATE_BOX
    	@UPDATE_VBGUEST ? $vagrant.vbguest.auto_update = @UPDATE_VBGUEST : nil
	end

	def base_ssh()
		id_rsa_path        = File.join(Dir.home, ".ssh", "id_rsa")
		id_rsa_ssh_key     = File.read(id_rsa_path)
		id_rsa_ssh_key_pub = File.read(File.join(Dir.home, ".ssh", "id_rsa.pub"))
		insecure_key_path  = File.join(Dir.home, ".vagrant.d", "insecure_private_key")
		# Set vagrant ssh settings
		$vagrant.ssh.insert_key = false
		$vagrant.ssh.forward_agent = true
		$vagrant.ssh.private_key_path = [id_rsa_path, insecure_key_path]
		# Add personal key into vm to assure faster ssh auth
    ssh_path = "/home/vagrant/.ssh"
    #fix_agent = "eval $(ssh-agent -s) && ssh-add"
    $vagrant.vm.provision :shell,
      privileged: false,
			inline: "echo '#{id_rsa_ssh_key}' > #{ssh_path}/id_rsa && chmod 600 #{ssh_path}/id_rsa"
    $vagrant.vm.provision :shell,
      privileged: false,
			inline: "echo '#{id_rsa_ssh_key_pub}' >> #{ssh_path}/authorized_keys && chmod 600 #{ssh_path}/authorized_keys"
	end

	def requirements()
		if @UPDATE_VBGUEST && !Vagrant.has_plugin?('vagrant-vbguest')
			system('vagrant plugin install vagrant-vbguest')
    end
    # Set @valid to true (component is ok)
    return true
	end
# end Base class
end
