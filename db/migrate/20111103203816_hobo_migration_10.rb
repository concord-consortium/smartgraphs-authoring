class HoboMigration10 < ActiveRecord::Migration
  def self.up
    add_column :predefined_graph_panes, :data, :text
  end

  def self.down
    remove_column :predefined_graph_panes, :data
  end
end
