class LineConsrtuctionAddPrecisionXY < ActiveRecord::Migration
  def self.up
    add_column :line_construction_sequences, :x_precision, :float, :default => 0.1
    add_column :line_construction_sequences, :y_precision, :float, :default => 0.1
  end

  def self.down
    remove_column :line_construction_sequences, :x_precision
    remove_column :line_construction_sequences, :y_precision
  end
end
