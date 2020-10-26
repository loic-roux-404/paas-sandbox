# Simplify errors 
# Show error in concerned config and suggest options
# Config error
class ConfigError < Exception
  S = "\n"
  BASE_MSG = "[=== Error in config ===]"+S

  def initialize(
    _concerned = "",
    _message = BASE_MSG,
    _type = 'standard',
    _exit = true
  )
    @message ||= _message
    @concerned = _concerned 
    puts self.send(_type)
  end

  def standard()
    @error = @message += "Concerned :#{@concerned}"
  end

    def missing()
    @error = BASE_MSG
    @concerned ? @error += "Concerned : #{self.concerned}"+S : nil
    @message ? @error += "Available Options : #{@message}"+S : nil
  end

  def concerned
    @concerned.is_a?(Array) ? @concerned.join(' '): @concerned
  end
end
