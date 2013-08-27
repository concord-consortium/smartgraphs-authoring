class AnimationMarkedCoordinate < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :animation

  fields do
    coordinate :float
    timestamps
  end

  # not sure why :required => true in the 'fields' block doesn't pass the spec and this does:
  validates :coordinate, :presence => true

  belongs_to :animation

end
