class AddToleranceToNumeric < ActiveRecord::Migration
  def self.up
    add_column :numeric_sequences, :tolerance, :float
  end

  def self.down
    remove_column :numeric_sequences, :tolerance
  end
end
