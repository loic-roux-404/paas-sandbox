# Ansible provisioner component
class Ansible < Component
  PLAYBOOK_PATH = "/tmp"
  DEFAULT_INVENTORY = 'inventory'
  GALAXY_ROLE_FILE_DEFAULT = 'roles/requirements.yml'

  def initialize(cnf, git)
    @git = git
    super(cnf)

    if @valid
      self.gen_git_script
      self.dispatch(@cnf.type)
    end
  end

  def ansible_local(ansible_mode = '_local')
    # Put playbook in guest
    if ansible_mode
      $vagrant.vm.provision :shell, inline: @get_playbook, privileged: false
    end
    # Start ansible-playbook command
    $vagrant.vm.provision 'ansible'+ansible_mode do |ansible|
      ansible.provisioning_path = "#{PLAYBOOK_PATH}/#{@cnf.playbook}/"
      ansible.playbook = @cnf.sub_playbook
      ansible.inventory_path = @cnf.inventory || DEFAULT_INVENTORY
      ansible.extra_vars = @cnf.vars.to_h
      ansible.compatibility_mode = '2.0'
      ansible.limit = 'all'
      ansible.galaxy_role_file = GALAXY_ROLE_FILE_DEFAULT
    end
  end

  def ansible_classic
    system(@get_playbook)
    self.ans_local('')
  end

  def ansible_worker
    $vagrant.vm.provision :shell,
      run: File.join(__dir__, '../', 'playbook-worker.sh'),
      args: "#{@git_url} #{@cnf.sub_playbook} #{@cnf.inventory}"
  end

  def gen_git_script
    if @cnf.playbook
      @git_url ="git@#{@git.provider}:#{@git.org}/#{@cnf.playbook}"
      full_path = "#{PLAYBOOK_PATH}/#{@cnf.playbook}"
      git_clone = "git clone #{@git_url} #{full_path}"
      @get_playbook = "rm -rf #{full_path} || true; #{git_clone}"
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
    # Set @valid to true (component is ok)
    return true
  end
  # end class Ansible
end
