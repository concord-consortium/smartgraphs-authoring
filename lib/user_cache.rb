class UserCache
  include Singleton
  
  instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }

  protected

  def method_missing(name, *args, &block)
    target.send(name, *args, &block)
  end
  
  def target
    @target ||= { }
  end
end
