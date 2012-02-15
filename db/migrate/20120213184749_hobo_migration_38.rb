class HoboMigration38 < ActiveRecord::Migration
  def self.up
    change_column :multiple_choice_sequences, :use_sequential_feedback, :boolean, :default => true
  end

  def self.down
    change_column :multiple_choice_sequences, :use_sequential_feedback, :boolean
  end
end
