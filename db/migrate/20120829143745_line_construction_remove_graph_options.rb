class LineConstructionRemoveGraphOptions < ActiveRecord::Migration
  def self.up
    remove_column :line_construction_sequences, :show_cross_hairs
    remove_column :line_construction_sequences, :show_tool_tip_coords
    remove_column :line_construction_sequences, :show_graph_grid
  end

  def self.down
    add_column :line_construction_sequences, :show_cross_hairs, :boolean, :default => true
    add_column :line_construction_sequences, :show_tool_tip_coords, :boolean, :default => false
    add_column :line_construction_sequences, :show_graph_grid, :boolean, :default => true
  end
end
