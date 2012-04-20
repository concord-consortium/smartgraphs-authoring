class ModifyDefaultTolerance < ActiveRecord::Migration
  def self.up
    change_column :numeric_sequences, :tolerance, :float, :default => 0.01
  end

  def self.down
    change_column :numeric_sequences, :tolerance, :float, :default => 0.1
  end
end
