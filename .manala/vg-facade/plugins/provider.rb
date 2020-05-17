# Vm provider component
class Provider < Component

  def initialize(cnf, project_name = '')
    @name = project_name 
    super(cnf)

    ENV['VAGRANT_DEFAULT_PROVIDER'] = cnf.type
    self.dispatch(cnf.type)
  end

  # create virtualbox config with VboxManage settings
  def provider_virtualbox
    $vagrant.vm.provider 'virtualbox' do |vb|
      vb.customize ['modifyvm', :id, "--name", @name]    
      @cnf.opts.each_pair do |param_id, value|
        # Convert booleans to virtualbox modifyvm params
        value = value.to_s != 'false' ? value : "off"
        value = value.to_s != 'true' ? value : "on"
        vb.customize ['modifyvm', :id, "--#{param_id}", value]
      end
    end
  end

  def provider_libvirt
    non_supported
  end

  def provider_vmware
    non_supported
  end

  def provider_parallels
    non_supported
  end

  def provider_docker
    non_supported
  end

  def requirements
    if !self.is_valid_type(@cnf.type)
      raise ConfigError.new(
        ['provider.type'], # options concerned
        self.type_list_str("\n - "), # suggest for option
        'missing'
      )
    end
  end

  def non_supported
    puts @cnf.type+" isn't supported for now"
    exit
  end
# end Class Provider#
end
