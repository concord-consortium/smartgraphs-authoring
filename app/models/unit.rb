class Unit < ActiveRecord::Base

  hobo_model # Don't put anything above this
  include SgMarshal
  
  fields do
    name         :string, :required, :unique
    abbreviation :string
    timestamps
  end

  def to_hash
    {
      'type' => 'Unit',
      'name' => name,
      'abbreviation' => abbreviation
    }
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
