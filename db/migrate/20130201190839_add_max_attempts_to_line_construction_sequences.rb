class AddMaxAttemptsToLineConstructionSequences < ActiveRecord::Migration
  def self.up
    add_column :line_construction_sequences, :max_attempts, :integer, :default => 3
  end

  def self.down
    remove_column :line_construction_sequences, :max_attempts
  end
end
