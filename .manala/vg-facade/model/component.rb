# Use this class as Mother class for any vagrant component
# Each Component cas use plugins corresponding to a sub method
# Depending on config choice a plugin is used 
# @example : config.network.type: private => private_network() method 
# PREFIX is used to identify methods of a component (ex "_network")
# To use don't forget to add the super(<YOUR-PREFIX>) method in Child initializer
class Component
  def initialize(cnf)
    @cnf = cnf
    @PREFIX = self.class.to_s.downcase+'_'
    @MapTypes = self.methods.grep(/#{@PREFIX}/).map(&:to_s)
    @valid = self.requirements
  end

  # Launch a type function
  def dispatch(type)
    self.send(@PREFIX+type)
  end

  # Launch all types function
  def dispatch_all
    @MapTypes.each do |type|
      self.send(type)
    end
  end
  # check if your component has valid plugin type
  # (ex check correct ansible provision process)
  def is_valid_type(plugin)
    plugin && @MapTypes.include?(@PREFIX+plugin)
  end

  # Get all component valid type in a listing string
  def type_list_str(glue = "\n")
    str = glue
    @MapTypes.each { |el| str += el.to_s.sub(/#{@PREFIX}/, '') + glue }
    return str.sub(/#{glue}$/, '')
  end
end

