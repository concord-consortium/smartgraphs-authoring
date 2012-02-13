class HoboMigration37 < ActiveRecord::Migration
  def self.up
    add_column :multiple_choice_sequences, :use_sequential_feedback, :boolean
  end

  def self.down
    remove_column :multiple_choice_sequences, :use_sequential_feedback
  end
end
