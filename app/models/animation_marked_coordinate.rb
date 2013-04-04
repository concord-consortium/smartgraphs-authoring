class AnimationMarkedCoordinate < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :animation

  fields do
    coordinate :float
    timestamps
  end

  belongs_to :animation

end
