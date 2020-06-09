# Fs Shared folders component
class Fs < Component
  ACTION_PROVISION ='.vagrant/machines/default/virtualbox/action_provision'

  def initialize(cnf, paths)
    @provisioned = File.exist? "#{$__dir__}/#{ACTION_PROVISION}"
    @host = paths.host
    @guest = paths.guest

    super(cnf)
    # Always disable default folder
    $vagrant.vm.synced_folder '.', '/vagrant', disabled: true
    @provisioned ? self.dispatch(cnf.type) : provision_trigger
  end

  def fs_rsync
    $vagrant.vm.synced_folder @host, @guest,
      disabled: @cnf.opts.disabled,
      type: 'rsync',
      rsync__auto: @cnf.opts.rsync_auto,
      rsync__args: ["--archive", "--delete", "--no-owner", "--no-group","-q", "-W"],
      rsync__exclude: @cnf.opts.ignored
  end

  def fs_nfs
    # NFS config / bind vagrant user to nfs mount
    if Vagrant::Util::Platform.darwin?
      $vagrant.vm.synced_folder @host, @guest,
        nfs: true,
        mount_options: ['rw','fsc','noatime','rsize=8192','wsize=8192','noacl','actimeo=2'],
        linux__nfs_options: ['rw','no_subtree_check','all_squash','async'],
        disabled: @cnf.opts.disabled
      $vagrant.bindfs.bind_folder @guest, @guest, after: :provision
    else
      # linux nfs 4 server
      $vagrant.vm.synced_folder @host, @guest,
        nfs: true,
        nfs_version: 4,
        nfs_udp: false,
        mount_options: ['rw','noac','actimeo=2','nolock'],
        disabled: @cnf.opts.disabled
    end
  end

  def fs_smb
    smb_user_pass = []
    @cnf.opts.smb_user ? smb_user_pass.push("username="+@cnf.opts.smb_user) : nil
    @cnf.opts.smb_password ? smb_user_password.push("password="+@cnf.opts.smb_password) : nil

    $vagrant.vm.synced_folder @host, @guest,
      type: 'smb',
      smb_username: @cnf.opts.smb_user,
      smb_password: @cnf.opts.smb_password,
      mount_options: ["vers=2.0"] + smb_user_pass,
      disabled: @cnf.opts.disabled
  end

  def fs_vbox()
    $vagrant.vm.synced_folder @host, @guest, disabled: @cnf.opts.disabled
  end

  def provision_trigger
    # reload shared folder after provision
    $vagrant.trigger.after :provision do |t|
      t.info = "Reboot after provisioning"
      t.run = { :inline => "vagrant reload" }
    end
  end

  def requirements
    if !self.is_valid_type(@cnf.type)
      raise ConfigError.new(
        ["config.fs.type"], # options concerned
        self.type_list_str("\n - "), # suggest option
        'missing'
      )
    end

    # NFS checks
    if @cnf.type == 'nfs'
      if Vagrant::Util::Platform.windows?
        raise ConfigError.new("NFS won't going to work with windows hosts (try WSL)")
      end

      Vagrant::Util::Platform.linux? ? system('apt-get install nfs-kernel-server nfs-common') : nil

		  if Vagrant::Util::Platform.darwin? && !Vagrant.has_plugin?('vagrant-bindfs')
        system('vagrant plugin install vagrant-bindfs')
      end
    end

    # SMB checks
    if @cnf.type == 'smb' && !Vagrant::Util::Platform.windows?
      raise ConfigError.new("SMB is for now only available on Windows")
    end
    # Set @valid to true (component is ok)
    return true
  end
# end Class Fs
end
