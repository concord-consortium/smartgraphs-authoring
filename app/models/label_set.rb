class LabelSet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgMarshal
  include SgPermissions
  sg_parent :activity

  belongs_to :activity

  fields do
    name :string, :required => true
    timestamps
  end

  def field_order
    "name"
  end

  def to_hash
    {
      'name' => name,
      'labels' => []
    }
  end


end