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

  def field_order
    "name, is_for_users"
  end

  def to_hash
    {
      'name' => name,
      'labels' => graph_labels.map(&:to_hash),
    }
  end

  def labels_from_hash(definition)
    # Because labels are actually GraphLabels, we need to handle them differently.
    self.graph_labels = definitions.map {|d| GraphLabel.from_hash(d)}
  end

  def is_for_users?
    is_for_users
  end

  def is_for_authors?
    !is_for_users
  end
end
