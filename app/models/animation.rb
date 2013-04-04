class Animation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name  :string
    y_min :float
    y_max :float
    timestamps
  end

  belongs_to :activity
  belongs_to :data_set
  has_many :animation_marked_coordinates, :dependent => :destroy

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
