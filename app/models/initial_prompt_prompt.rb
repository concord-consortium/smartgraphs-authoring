class InitialPromptPrompt < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include StandardPermissions

  fields do
    timestamps
  end

  # the various sequence models to which a prompt can belong
  belongs_to :pick_a_point_sequence
  belongs_to :numeric_sequence

  # the hint itself
  belongs_to :prompt, :polymorphic => true, :index => 'index_initial_prompt_prompts'

end
