class Animation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string, :required => true
    y_min :float, :required => true
    y_max :float, :required => true
    timestamps
  end

  belongs_to :activity
  # not marked as required so that a user can choose to create an animation, *then* its data set
  belongs_to :data_set
  has_many :animation_marked_coordinates, :dependent => :destroy

  validates :name, :uniqueness => {
    :scope => :activity_id,
    :message => "is already used elsewhere in the activity"
  }

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
