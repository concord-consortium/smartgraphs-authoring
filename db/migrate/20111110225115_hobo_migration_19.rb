class HoboMigration19 < ActiveRecord::Migration
  def self.up
    add_column :confirm_correct_prompts, :numeric_sequence_id, :integer

    add_column :give_up_prompts, :numeric_sequence_id, :integer

    add_column :initial_prompt_prompts, :numeric_sequence_id, :integer

    add_index :confirm_correct_prompts, [:numeric_sequence_id], :name => 'indx_confirm_correct_numeric_seq_id'

    add_index :give_up_prompts, [:numeric_sequence_id], :name => 'indx_give_up_numeric_seq_id'

    add_index :initial_prompt_prompts, [:numeric_sequence_id], :name => 'indx_initial_prompt_numeric_seq_id'
  end

  def self.down
    remove_column :confirm_correct_prompts, :numeric_sequence_id

    remove_column :give_up_prompts, :numeric_sequence_id

    remove_column :initial_prompt_prompts, :numeric_sequence_id

    remove_index :confirm_correct_prompts, :name => :indx_confirm_correct_numeric_seq_id rescue ActiveRecord::StatementInvalid

    remove_index :give_up_prompts, :name => :indx_give_up_numeric_seq_id rescue ActiveRecord::StatementInvalid

    remove_index :initial_prompt_prompts, :name => :indx_initial_prompt_numeric_seq_id rescue ActiveRecord::StatementInvalid
  end
end
