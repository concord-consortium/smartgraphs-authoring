class InitialPromptPrompt < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end

  # the various sequence models to which a prompt can belong
  belongs_to :pick_a_point_sequence
  belongs_to :numeric_sequence

  # the hint itself
  belongs_to :prompt, :polymorphic => true, :index => 'index_initial_prompt_prompts'

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
