class LabelSet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :activity

  fields do
    name :string, :required => true
    timestamps
  end

  belongs_to :activity

end
