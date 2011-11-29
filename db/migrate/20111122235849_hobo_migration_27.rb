class HoboMigration27 < ActiveRecord::Migration
  def self.up
    add_column :prediction_graph_panes, :prediction_type, :string
  end

  def self.down
    remove_column :prediction_graph_panes, :prediction_type
  end
end
