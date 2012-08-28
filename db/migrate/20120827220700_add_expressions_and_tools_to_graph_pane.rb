class AddExpressionsAndToolsToGraphPane < ActiveRecord::Migration
  def self.up
    add_column :predefined_graph_panes, :expression, :string, :default => ""
    add_column :predefined_graph_panes, :line_snap_distance, :float, :default => 0.1
    add_column :predefined_graph_panes, :line_type, :string, :default => "none"
    add_column :predefined_graph_panes, :point_type, :string, :default => "disc"
    add_column :predefined_graph_panes, :show_cross_hairs, :boolean, :default => false
    add_column :predefined_graph_panes, :show_graph_grid, :boolean, :default => false
    add_column :predefined_graph_panes, :show_tool_tip_coords, :boolean, :default => false
  end

  def self.down
    remove_column :predefined_graph_panes, :expression
    remove_column :predefined_graph_panes, :line_snap_distance
    remove_column :predefined_graph_panes, :line_type
    remove_column :predefined_graph_panes, :point_type
    remove_column :predefined_graph_panes, :show_cross_hairs
    remove_column :predefined_graph_panes, :show_graph_grid
    remove_column :predefined_graph_panes, :show_tool_tip_coords
  end
end
