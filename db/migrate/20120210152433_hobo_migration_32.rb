class HoboMigration32 < ActiveRecord::Migration
  def self.up
    remove_index :multiple_choice_choices, :name => :index_multiple_choice_choices_on_multiple_choice_sequence_id rescue ActiveRecord::StatementInvalid
    add_index :multiple_choice_choices, [:multiple_choice_sequence_id], :name => 'multiple_choice_sequence_multiple_choice_choice_index'
  end

  def self.down
    remove_index :multiple_choice_choices, :name => :multiple_choice_sequence_multiple_choice_choice_index rescue ActiveRecord::StatementInvalid
    add_index :multiple_choice_choices, [:multiple_choice_sequence_id]
  end
end
