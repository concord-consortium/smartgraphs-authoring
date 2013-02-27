class AddMoreVisualPromptsToMultipleChoiceSequences < ActiveRecord::Migration
  def self.up
    add_column :confirm_correct_prompts, :multiple_choice_sequence_id, :integer

    add_column :give_up_prompts, :multiple_choice_sequence_id, :integer

    add_index :confirm_correct_prompts, [:multiple_choice_sequence_id]

    add_index :give_up_prompts, [:multiple_choice_sequence_id]
  end

  def self.down
    remove_column :confirm_correct_prompts, :multiple_choice_sequence_id

    remove_column :give_up_prompts, :multiple_choice_sequence_id

    remove_index :confirm_correct_prompts, :name => :index_confirm_correct_prompts_on_multiple_choice_sequence_id rescue ActiveRecord::StatementInvalid

    remove_index :give_up_prompts, :name => :index_give_up_prompts_on_multiple_choice_sequence_id rescue ActiveRecord::StatementInvalid
  end
end
