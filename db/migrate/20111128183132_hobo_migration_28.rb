class HoboMigration28 < ActiveRecord::Migration
  def self.up
    add_column :pick_a_point_sequences, :correct_answer_x_min, :float
    add_column :pick_a_point_sequences, :correct_answer_y_min, :float
    add_column :pick_a_point_sequences, :correct_answer_x_max, :float
    add_column :pick_a_point_sequences, :correct_answer_y_max, :float
  end

  def self.down
    remove_column :pick_a_point_sequences, :correct_answer_x_min
    remove_column :pick_a_point_sequences, :correct_answer_y_min
    remove_column :pick_a_point_sequences, :correct_answer_x_max
    remove_column :pick_a_point_sequences, :correct_answer_y_max
  end
end
