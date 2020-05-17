# Ansible provisioner component
class Ansible < Component
  PREFIX = 'ans_'
  PLAYBOOK_PATH = "~/.ansible"
  
  def initialize(cnf, git)
    @git = git
    super(cnf)

    if @valid
      parse_config
      self.dispatch(@cnf.type)
    end
  end

  def ansible_local(local = true)
    # Put playbook in guest
    if local 
      $vagrant.vm.provision :shell, inline: @git_clone
    end
    # Start ansible-playbook command  
    $vagrant.vm.provision ansible_mode_id do |ansible|
      ansible.provisioning_path = "#{PLAYBOOK_PATH}"
      ansible.playbook = @cnf.playbook
      ansible.inventory_path = @cnf.inventory # TODO : case no inventory
      ansible.extra_vars = @cnf.extra_vars
    end
  end

  def ansible_classic
    system(git_clone)
    self.ans_local(false)
  end

  def ansible_worker
    $vagrant.vm.provision :shell,
      run: File.join(__dir__, '../', 'playbook-worker.sh'),
      args: "#{@git_url} #{@cnf.sub_playbook} #{@cnf.inventory}"
  end

  def parse_config
    if @cnf.playbook
      @git_url = [
        @git.provider, 
        @git.org,
        @cnf.playbook
      ].join('/')
      @git_clone = "git clone #{@git_url} #{PLAYBOOK_PATH}/#{@cnf.playbook} "
    end
  end

  def requirements
    if @cnf.disabled || !@git.org || !@cnf.playbook
      return false
    end

    if !self.is_valid_type(@cnf.type)
      raise ConfigError.new(
        ['ansible.type'], # options concerned
        self.type_list_str("\n - "), # suggest for valid process of this component
        'missing'
      )
    end
  end
  # end class Ansible
end
