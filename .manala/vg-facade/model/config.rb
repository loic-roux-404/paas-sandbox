require 'yaml'

# Class Config : interface with config files
class Config
  DEFAULT_CONFIG = '/.manala.yaml'
  CONFIG_OBJECT_KEY = 'vagrant'
  USER_CONFIG = '/config.yaml'
  HELPER_MSG = <<-HELPER
# Override original config in #{DEFAULT_CONFIG }
# Useful to pass ansible extra vars or add RAM to VM
---
#{CONFIG_OBJECT_KEY}:
HELPER

  def initialize
    @default = YAML.load_file($__dir__+ DEFAULT_CONFIG)[CONFIG_OBJECT_KEY]
    self.check_user_cnf
    @user_config = YAML.load_file($__dir__ + USER_CONFIG)
    @config = @default.deep_merge(@user_config)
  end

  # Request a config by index
  def get(index = '')
    if !@config[index.to_s]
      gen_base(@config).to_struct
    elsif !@config[index.to_s].is_a?(Hash)
       @config[index.to_s]
    else
      @config[index.to_s].to_struct
    end
  end

  # Create base from config.json root
  def gen_base(config)
    res = {}
    config.each do |key, value|
      !value.is_a?(Hash) && !value.is_a?(Array) ? res[key] = value : nil
    end
    res
  end

  # Create missing user config if needed
  def check_user_cnf
    begin
      File.read($__dir__ + USER_CONFIG)
    rescue StandardError
      puts 'Creating missing config'
      user_config_file = File.open($__dir__ + USER_CONFIG, 'w+')
      user_config_file.puts HELPER_MSG
      user_config_file.close
    end
  end
end
