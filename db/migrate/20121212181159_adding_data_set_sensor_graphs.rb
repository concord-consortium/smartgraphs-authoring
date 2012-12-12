class AddingDataSetSensorGraphs < ActiveRecord::Migration
  def self.up
    create_table :data_set_sensor_graphs do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :data_set_id
      t.integer  :sensor_graph_pane_id
    end
    add_index :data_set_sensor_graphs, [:data_set_id]
    add_index :data_set_sensor_graphs, [:sensor_graph_pane_id]
  end

  def self.down
    drop_table :data_set_sensor_graphs
  end
end
