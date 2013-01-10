# Class that SgMarshall can be mixed in to
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
  
  # stub AR method
  def self.reflect_on_all_associations(association_symbol)
    case association_symbol
    when :has_many  # stub for has_many :dummy_children
      [OpenStruct.new(:name => :dummy_children)]
    when :has_one
      []
    when :belongs_to
      []
    else
      []
    end
  end

  # stub AR save
  def save
  end
end

# Class that SgMarshall can be mixed in to
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

  def save
  end
end
