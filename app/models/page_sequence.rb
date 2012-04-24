class PageSequence < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include StandardPermissions

  fields do
    timestamps
  end

  belongs_to :page
  belongs_to :sequence, :polymorphic => true, :index => 'index_sequences'

end
