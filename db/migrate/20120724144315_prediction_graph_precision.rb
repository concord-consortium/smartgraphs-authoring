class PredictionGraphPrecision < ActiveRecord::Migration
  def self.up
    add_column :prediction_graph_panes, :y_precision, :float, :default => 0.1
    add_column :prediction_graph_panes, :x_precision, :float, :default => 0.1
  end

  def self.down
    remove_column :prediction_graph_panes, :y_precision
    remove_column :prediction_graph_panes, :x_precision
  end
end
