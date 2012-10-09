class SubjectArea < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  include SgMarshal         # serialization.
  # include SgAdminOnlyModel  # admin only permissions.
  
  fields do
    name         :string, :required, :unique
    timestamps
  end

  def to_hash
    {
      'type' => 'SubjectArea',
      'name' => name
    }
  end
  
  has_many :activity_subject_areas
  has_many :activities, :through => :activity_subject_areas


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
