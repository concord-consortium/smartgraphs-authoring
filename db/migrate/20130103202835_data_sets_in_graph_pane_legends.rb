class DataSetsInGraphPaneLegends < ActiveRecord::Migration
  def self.up
    add_column :data_set_predefined_graphs, :in_legend, :boolean, :default => false

    add_column :data_set_sensor_graphs, :in_legend, :boolean, :default => false

    add_column :data_set_prediction_graphs, :in_legend, :boolean, :default => false
  end

  def self.down
    remove_column :data_set_predefined_graphs, :in_legend

    remove_column :data_set_sensor_graphs, :in_legend

    remove_column :data_set_prediction_graphs, :in_legend
  end
end
