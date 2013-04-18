class LabelSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # TODO: We could have these be i18nized constants....
  def self.defaults
    @defaults ||= {
      'text'        => "Place a label on the graph.",
    }
  end

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  sg_parent :page

  fields do
    title         :string, :default => 'New label sequence'
    text          :raw_html
    label_count   :integer, :default => 1
    timestamps
  end

  def field_order
    "title, text, label_count"
  end

  has_one :page_sequence, :as => :sequence, :dependent => :destroy
  has_one :page, :through => :page_sequence
  reverse_association_of :page, 'Page#label_sequences'

  belongs_to :label_set, :conditions => 'is_for_users = 1'
  
  before_validation :default_text_values
  before_validation :ensure_label_set

  validates :title,                 :presence => true
  validates :label_count,           :numericality => true

  def to_hash
    {
      "type"            => type,
      "title"           => title,
      "text"            => text,
      "labelSetName"    => label_set ? label_set.name : nil,
      "numberOfLabels"  => label_count
    }
  end

  def type
    "LabelSequence"
  end

  def label_set_name_from_hash(definition)
    callback = Proc.new do
      self.reload
      found_label_set = self.page.activity.label_sets.find_by_name(definition)
      self.label_set = found_label_set
      self.save!
    end
    self.add_marshal_callback(callback)
  end

  def number_of_labels_from_hash(definition)
    self.label_count = definition.to_i
  end

  protected
  def default_text_values
    LabelSequence.defaults.each_pair do |key,value|
      # self.attributes[key] ||= value
      self.send("#{key}=", value) if self.send(key).nil? || self.send(key).empty?
    end
  end

  def ensure_label_set
    if !label_set.present? && page.present?
      create_label_set(:is_for_users => true, :activity_id => page.activity.id, :name => "Labels for #{title}")
    end
  end
end
