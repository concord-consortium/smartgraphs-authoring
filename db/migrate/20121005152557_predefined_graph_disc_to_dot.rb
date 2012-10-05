class PredefinedGraphDiscToDot < ActiveRecord::Migration

  def self.up
    execute "UPDATE predefined_graph_panes set point_type='dot' where point_type = 'disc'"
  end

  def self.down
    execute "UPDATE predefined_graph_panes set point_type='disc' where point_type = 'dot'"
  end
end

