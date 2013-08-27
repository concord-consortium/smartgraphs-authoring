class LabelSet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgMarshal
  include SgPermissions
  sg_parent :activity

  belongs_to :activity
  has_many :graph_labels, :accessible => true

  has_many :predefined_graph_panes, :through => :label_set_predefined_graphs
  has_many :label_set_predefined_graphs, :dependent => :destroy

  fields do
    name :string, :required => true
    is_for_users :boolean, :default => false
    timestamps
  end

  validates :name, :uniqueness => {
    :scope => :activity_id,
    :message => "is already used elsewhere in the activity"
  }

  scope :for_users, where(:is_for_users => true)
  scope :for_authors, where(:is_for_users => false)

  def field_order
    "name, is_for_users"
  end

  def to_hash
    {
      'name' => name,
      'labels' => graph_labels.map(&:to_hash),
    }
  end

  def labels_from_hash(definitions)
    # Because labels are actually GraphLabels, we need to handle them differently.
    self.graph_labels = definitions.map do |d|
      GraphLabel.create!(:text => d['text'], :name => d['name'], :x_coord => d['point'][0], :y_coord => d['point'][1], )
    end
  end

  def is_for_users?
    is_for_users
  end

  def is_for_authors?
    !is_for_users
  end
end
