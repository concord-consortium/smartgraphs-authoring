# Class that SgMarshal can be mixed in to
class DummyMarshal
  attr_accessor :attr1_key, :attr2_key, :Attr3Key, :attr4_key, :attr5_key, :attr6_key

  include SgMarshal

  def initialize(attrs= { })
    attrs.each{ |k,v| send("#{k}=", v) if self.respond_to?("#{k}=")}

    # stub for Rails has_many
    @dummy_children = []
  end

  ########################
  # SgMarshal requires all the below methods on models it's included in.
  ########################
  
  # SgMarshal requires this method added to models by Hobo
  def self.attr_order
    [:attr4_key, :attr2_key, :attr1_key, :attr5_key, :attr6_key]
  end

  # stub for has_many :dummy_children
  def dummy_children
    @dummy_children 
  end
  
  # stub AR methods
  def self.create_reflection(macro, name, options, active_record)
    ActiveRecord::Reflection::AssociationReflection.new(macro, name, options, active_record)
  end

  def self.reflect_on_all_associations(association_symbol)
    case association_symbol
    when :has_many  # stub for has_many :dummy_children
      [create_reflection(:has_many, 'dummy_children', {}, self)]
    when :has_one
      []
    when :belongs_to
      []
    else
      []
    end
  end

  # stub AR save
  def save(args)
  end
end

# Class that SgMarshal can be mixed in to
class DummyChild
  attr_accessor :attr1, :attr2
  include SgMarshal

  def initialize(attrs= { })
    attrs.each{ |k,v| send("#{k}=", v) if self.respond_to?("#{k}=")}
  end

  ########################
  # SgMarshal requires all the below methods on models it's included in.
  ########################

  # Included into AR by Hobo
  def self.attr_order
    [:attr1, :attr2]
  end

  # From AR
  def self.reflect_on_all_associations(association_symbol)
    []
  end

  def save(args)
  end
end

class ASequence
  attr_accessor :attr1
  include SgMarshal

  def initialize(attrs= { })
    attrs.each{ |k,v| send("#{k}=", v) if self.respond_to?("#{k}=")}
  end

  # These relationship definitions in an AR model would set up the reflections below.
  # belongs_to :b_data_set
  # belongs_to :other_data, :class_name => 'BDataSet'

  def b_data_set
    @b_data_set
  end

  def b_data_set=(new_data_set)
    @b_data_set = new_data_set
  end

  def other_data=(new_data_set)
    @other_data = new_data_set
  end

  def other_data
    @other_data
  end

  # SgMarshal uses these ActiveRecord methods
  def self.attr_order
    [:attr1]
  end

  def self.create_reflection(macro, name, options, active_record)
    ActiveRecord::Reflection::AssociationReflection.new(:belongs_to, name, options, active_record)
  end

  def associates
    return ASequence.reflect_on_all_associations
  end

  # AR would get the reflection from its cached array of them, but we'll just create them on the fly
  def self.reflect_on_association(association)
    case association
    when :b_data_set
      return create_reflection(:belongs_to, 'b_data_set', {}, self)
    when :other_data
      return create_reflection(:belongs_to, 'other_data', {:class_name => 'BDataSet'}, self)
    else
      return nil
    end
  end

  # Get a list of all ActiveRecord AssociationReflections (optionally scoped to an association type, e.g. :belongs_to)
  def self.reflect_on_all_associations(association_symbol=nil)
    if association_symbol.blank? || association_symbol == :belongs_to
      return [
        self.reflect_on_association(:b_data_set),
        self.reflect_on_association(:other_data)
      ]
    else
      return []
    end
  end

  # We don't really want to save these
  def save(args)
  end

  # The SgMarshal methods
  def to_hash
    {
      'type'        => 'ASequence',
      'attr1'       => attr1,
      'bDataSet'    => b_data_set.to_hash,
      'otherData'   => other_data.to_hash
    }
  end
end

class BDataSet
  attr_accessor :name
  include SgMarshal

  def initialize(attrs= { })
    attrs.each{ |k,v| send("#{k}=", v) if self.respond_to?("#{k}=")}
  end

  # SgMarshal uses these ActiveRecord methods
  def self.attr_order
    [:name]
  end

  def self.reflect_on_all_associations(association_symbol)
    []
  end

  def save(args)
  end

  def to_hash
    {
      'type'  => 'BDataSet',
      'name'  => name
    }
  end
end
