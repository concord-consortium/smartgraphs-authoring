class PagePane < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  sg_parent :page
  
  fields do
    timestamps
  end

  belongs_to :page
  belongs_to :pane, :polymorphic => true

  # TODO: This should be scoped to page?
  acts_as_list

end
