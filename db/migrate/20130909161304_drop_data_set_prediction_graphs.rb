class DropDataSetPredictionGraphs < ActiveRecord::Migration
  class DataSetPredictionGraph < ActiveRecord::Base
  end

  def self.up
    DataSetPredictionGraph.reset_column_information
    DataSetPredictionGraph.all.each do |dspg|
      dsp = DataSetPane.new(:data_set_id => dspg.data_set_id, :pane_id => dspg.prediction_graph_pane_id, :in_legend => dspg.in_legend, :pane_type => 'PredictionGraphPane')
      dsp.save
    end
    drop_table :data_set_prediction_graphs
  end

  def self.down
    create_table "data_set_prediction_graphs", :force => true do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "data_set_id"
      t.integer  "prediction_graph_pane_id"
      t.boolean  "in_legend",                :default => false
    end

    add_index "data_set_prediction_graphs", ["data_set_id"], :name => "index_data_set_prediction_graphs_on_data_set_id"
    add_index "data_set_prediction_graphs", ["prediction_graph_pane_id"], :name => "index_data_set_prediction_graphs_on_prediction_graph_pane_id"
  end
end
