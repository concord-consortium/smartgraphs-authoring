class AddGraphGridToPanes < ActiveRecord::Migration
  def self.up
    add_column :prediction_graph_panes, :show_cross_hairs, :boolean, :default => false
    add_column :prediction_graph_panes, :show_graph_grid, :boolean, :default => false
    add_column :prediction_graph_panes, :show_tool_tip_coords, :boolean, :default => false

    add_column :sensor_graph_panes, :show_cross_hairs, :boolean, :default => false
    add_column :sensor_graph_panes, :show_graph_grid, :boolean, :default => false
    add_column :sensor_graph_panes, :show_tool_tip_coords, :boolean, :default => false
  end

  def self.down
    remove_column :prediction_graph_panes, :show_cross_hairs
    remove_column :prediction_graph_panes, :show_graph_grid
    remove_column :prediction_graph_panes, :show_tool_tip_coords

    remove_column :sensor_graph_panes, :show_cross_hairs
    remove_column :sensor_graph_panes, :show_graph_grid
    remove_column :sensor_graph_panes, :show_tool_tip_coords
  end
end
