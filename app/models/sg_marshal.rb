module SgMarshal
  module ClassMethods
    def from_hash(defs)
      defs               = Hash[defs.map {|k,v| [k.underscore, v]}]
      object             = self.new(filter_attributes(defs))
      object.create_hash = defs
      object.create_collections
      object.create_associations
      object.process_nested_lists
      object.custom_from_hashes
      object.save
      object
    end

    def filter_attributes(_in_hash)
      # handle edge cases where value is a hash with one text key...
      # custom munging too:
      return_hash            = Hash[_in_hash.map {|k,v| [k, v.kind_of?(Hash)  ? v['text'] : v]}]
      return_hash['name']  ||= return_hash['initial_prompt']
      return_hash['title'] ||= return_hash['name']
      return_hash = return_hash.select { |k,v| self.attr_order.include? k.to_sym }
      return_hash.reject { |k,v| v.kind_of?(Array) }
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  def process_nested_lists
    defs = self.create_hash
    defs = defs.reject do |k,v|
      self.associates.include? k.to_sym
      self.collections.include? k.to_sym
      self.class.attr_order.include? k.to_sym
    end
    defs.each do |definition|
      if definition.kind_of? Array
        definition.each do |d|
          if d.kind_of?(Hash) && d['type']
            #TODO: move this logic elsewhere: I smell factory pattern.
            klass_name = d['type']
            if klass_name == 'MultipleChoiceWithSequentialHintsSequence'
              klass_name = 'MultipleChoiceSequence'
              d['use_sequential_feedback'] = true
            elsif klass_name == 'MultipleChoiceWithCustomHintsSequence'
              klass_name = 'MultipleChoiceSequence'
              d['use_sequential_feedback'] = false
            end
            klass = klass_name.constantize
            assoc_name = klass_name.underscore.pluralize
            if self.respond_to? assoc_name
              begin
                obj = klass.from_hash(d)
                self.send(assoc_name.to_sym) << obj
              rescue => detail
                puts "unable to convert #{klass} from hash\n\n #{d.inspect}\n\n(#{assoc_name})"
                puts  detail
                print detail.backtrace.join("\n")
              end
            else
              puts "#{self} doesn't respond to #{assoc_name}"
            end
          end
        end
      else
        puts "unable to process definition in #{self} #{definition}"
      end
    end
  end

  # checks for self#foo_from_hash implementations
  def custom_from_hashes
    self.create_hash.each_pair do |key,value|
      method_name = "#{key}_from_hash".to_sym
      if self.respond_to?(method_name)
        self.send(method_name,value)
      end
    end
  end

  # create  collections from hashes
  def create_collections
    self.collections.each do |collection_name|
      self.add_collection(collection_name)
    end
  end

  # create  1 <-> 1 assns from hashes
  def create_associations
    self.associates.each do |associates_name|
      self.add_associated(associates_name)
    end
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


