class AddSensorGraphsToDataSetPanes < ActiveRecord::Migration
  class DataSetSensorGraph < ActiveRecord::Base
  end

  def self.up
    DataSetSensorGraph.reset_column_information
    DataSetSensorGraph.all.each do |dssg|
      dsp = DataSetPane.new(:data_set_id => dssg.data_set_id, :pane_id => dssg.sensor_graph_pane_id, :in_legend => dssg.in_legend, :pane_type => 'SensorGraphPane')
      dsp.save!
    end

    drop_table :data_set_sensor_graphs
  end

  def self.down
    create_table "data_set_sensor_graphs", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "data_set_id"
      t.integer  "sensor_graph_pane_id"
      t.boolean  "in_legend",            :default => false
    end

    add_index "data_set_sensor_graphs", ["data_set_id"], :name => "index_data_set_sensor_graphs_on_data_set_id"
    add_index "data_set_sensor_graphs", ["sensor_graph_pane_id"], :name => "index_data_set_sensor_graphs_on_sensor_graph_pane_id"
  end
end
