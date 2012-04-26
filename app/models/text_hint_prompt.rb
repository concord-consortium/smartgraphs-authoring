class TextHintPrompt < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include StandardPermissions
  parent :text_hint
  
  fields do
    timestamps
  end

  belongs_to :text_hint
  belongs_to :prompt, :polymorphic => true, :index => 'index_prompts'

end
