class Animation < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name               :string
    y_min              :float
    y_max              :float
    marked_coordinates :text
    timestamps
  end

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
