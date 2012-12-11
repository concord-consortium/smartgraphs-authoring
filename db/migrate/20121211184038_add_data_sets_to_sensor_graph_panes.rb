class AddDataSetsToSensorGraphPanes < ActiveRecord::Migration
  def self.up
    add_column :sensor_graph_panes, :data_set_id, :integer

    add_index :sensor_graph_panes, [:data_set_id]
  end

  def self.down
    remove_column :sensor_graph_panes, :data_set_id

    remove_index :sensor_graph_panes, :name => :index_sensor_graph_panes_on_data_set_id rescue ActiveRecord::StatementInvalid
  end
end
