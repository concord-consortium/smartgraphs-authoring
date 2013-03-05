class AddInitialVisualPromptsToMultipleChoiceSequences < ActiveRecord::Migration
  def self.up
    add_column :initial_prompt_prompts, :multiple_choice_sequence_id, :integer

    add_index :initial_prompt_prompts, [:multiple_choice_sequence_id]
  end

  def self.down
    remove_column :initial_prompt_prompts, :multiple_choice_sequence_id

    remove_index :initial_prompt_prompts, :name => :index_initial_prompt_prompts_on_multiple_choice_sequence_id rescue ActiveRecord::StatementInvalid
  end
end
