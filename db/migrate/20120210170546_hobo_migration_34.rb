class HoboMigration34 < ActiveRecord::Migration
  def self.up
    add_column :multiple_choice_hints, :multiple_choice_sequence_id, :integer

    add_index :multiple_choice_hints, [:multiple_choice_sequence_id], :name => 'multiple_choice_sequence_multiple_choice_hint_index'
  end

  def self.down
    remove_column :multiple_choice_hints, :multiple_choice_sequence_id

    remove_index :multiple_choice_hints, :name => :multiple_choice_sequence_multiple_choice_hint_index rescue ActiveRecord::StatementInvalid
  end
end
