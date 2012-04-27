module SgMarshal
  module ClassMethods
    def from_hash(defs)
      klass              = self
      defs               = Hash[defs.map {|k,v| [k.underscore, v]}]
      allowed_attributes = klass.attr_order
      create_hash        = defs.select { |k,v| allowed_attributes.include? k.to_sym }
      # handle arrays that get serlialized by active record:
      create_hash        = Hash[create_hash.map {|k,v| [k, v.kind_of?(Array) ? v.to_s : v]}]
      object             = self.create(create_hash)
      object.create_hash = defs
      object.collections.each do |collection_name|
        object.add_collection(collection_name)
      end
      object.associates.each do |associates_name|
        object.add_associated(associates_name)
      end

      # cusomize as needed with foo_from_hash in your classes:
      defs.each_pair do |key,value|
        method_name = "#{key}_from_hash".to_sym

        if object.respond_to? method_name
          object.send method_name value
        end
      end

      # return the object
      object
    end
  end

  def self.included(base)
    puts "including #{self} in #{base}"
    base.extend(ClassMethods)
  end

  def create_hash=(defs)
    @create_hash = defs
  end

  def create_hash
    @create_hash
  end

  def collections
    self.class.reflect_on_all_associations(:has_many).map { |c| c.name }
  end
  
  def associates
    associates  = self.class.reflect_on_all_associations(:has_one).map    { |c| c.name }
    associates  + self.class.reflect_on_all_associations(:belongs_to).map { |c| c.name }
  end

  def create_associated(symbol,definition)
    class_name = symbol.singularize.camelcase
    klass = class_name.constantize
    klass.from_hash(definition)
  end

  def add_collection(symbol)
    sym_string = symbol.to_s
    return unless self.create_hash.has_key?(sym_string)
    defs = self.create_hash[sym_string]
    defs.each do |definition|
      object = self.create_associated(sym_string,definition)
      self.send(symbol) << object
    end
  end

  def add_associated(symbol)
    sym_string = symbol.to_s
    return unless self.create_hash.has_key?(sym_string)
    defs = self.create_hash[sym_string]
    self.send "#{symbol}=".to_sym, create_associated(sym_string,defs)
  end
end


