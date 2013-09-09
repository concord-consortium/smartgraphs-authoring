class DataSetPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  sg_parent :page
  
  fields do
    in_legend :boolean, :default => false
    timestamps
  end

  belongs_to :data_set
  belongs_to :pane, :polymorphic => true

end
