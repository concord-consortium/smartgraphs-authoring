class LineConstructionTitle < ActiveRecord::Migration
  def self.up
    rename_column :line_construction_sequences, :name, :title
    change_column :line_construction_sequences, :slope_tolerance, :float, :default => 0.1
  end

  def self.down
    rename_column :line_construction_sequences, :title, :name
    change_column :line_construction_sequences, :slope_tolerance, :float, :default => 0.0
  end
end
