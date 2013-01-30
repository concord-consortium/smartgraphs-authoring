class AddGiveUpToBestFitSequence < ActiveRecord::Migration
  def self.up
    add_column :best_fit_sequences, :give_up, :text
  end

  def self.down
    remove_column :best_fit_sequences, :give_up
  end
end
