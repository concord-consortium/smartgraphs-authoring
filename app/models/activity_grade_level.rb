class ActivityGradeLevel < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  sg_parent :activity
  
  fields do
    timestamps
  end
  
  belongs_to :activity
  belongs_to :grade_level
  
end
