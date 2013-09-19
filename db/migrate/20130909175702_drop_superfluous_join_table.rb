class DropSuperfluousJoinTable < ActiveRecord::Migration
  def self.up
    # Originally this migration had a line to drop a table which was created on a never-merged branch...
    change_column :label_set_graph_panes, :pane_type, :string, :limit => 255, :default => nil
  end

  def self.down
    change_column :label_set_graph_panes, :pane_type, :string, :default => "PredefinedGraphPane"
  end
end
