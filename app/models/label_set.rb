class LabelSet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :activity

  fields do
    name :string, :required => true
    timestamps
  end

  belongs_to :activity

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
