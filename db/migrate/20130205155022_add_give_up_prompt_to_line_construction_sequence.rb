class AddGiveUpPromptToLineConstructionSequence < ActiveRecord::Migration
  def self.up
    add_column :line_construction_sequences, :give_up, :text
  end

  def self.down
    remove_column :line_construction_sequences, :give_up
  end
end
