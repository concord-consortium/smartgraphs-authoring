class Animation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :activity

  fields do
    name  :string, :required => true
    y_min :float, :required => true
    y_max :float, :required => true
    timestamps
  end

  belongs_to :activity
  # not marked as required so that a user can choose to create an animation, *then* its data set
  belongs_to :data_set
  has_many :animation_marked_coordinates, :dependent => :destroy, :accessible => true

  validates :name, :uniqueness => {
    :scope => :activity_id,
    :message => "is already used elsewhere in the activity"
  }
  validates :name, :length => { :minimum => 1 }

  def field_order
    "name, data_set, y_min, y_max"
  end
end
