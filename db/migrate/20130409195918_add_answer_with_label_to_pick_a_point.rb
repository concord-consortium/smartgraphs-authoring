class AddAnswerWithLabelToPickAPoint < ActiveRecord::Migration
  def self.up
    add_column :pick_a_point_sequences, :answer_with_label, :boolean
  end

  def self.down
    remove_column :pick_a_point_sequences, :answer_with_label
  end
end
