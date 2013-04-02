class LabelSet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgMarshal
  include SgPermissions
  sg_parent :activity

  belongs_to :activity
  has_many :labels

  fields do
    name :string, :required => true
    timestamps
  end

  validates :name, :uniqueness => {
    :scope => :activity_id,
    :message => "is already used elsewhere in the activity"
  }

  def field_order
    "name"
  end

  def to_hash
    {
      'name' => name,
      'labels' => labels.map(&:to_hash),
    }
  end


end
