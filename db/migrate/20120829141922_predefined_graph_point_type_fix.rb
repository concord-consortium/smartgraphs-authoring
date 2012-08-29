class PredefinedGraphPointTypeFix < ActiveRecord::Migration
  def self.up
    change_column :predefined_graph_panes, :point_type, :string, :limit => 255, :default => "dot"
  end

  def self.down
    change_column :predefined_graph_panes, :point_type, :string, :default => "disc"
  end
end
