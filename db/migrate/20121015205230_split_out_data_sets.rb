class SplitOutDataSets < ActiveRecord::Migration
  def self.up
    create_table :data_sets do |t|
      t.string   :name
      t.float    :y_precision, :default => 0.1
      t.float    :x_precision, :default => 0.1
      t.float    :line_snap_distance, :default => 0.1
      t.string   :expression, :default => ""
      t.string   :line_type, :default => "none"
      t.string   :point_type, :default => "dot"
      t.text     :data
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :y_unit_id
      t.integer  :x_unit_id
      t.integer  :activity_id
    end
    add_index :data_sets, [:y_unit_id]
    add_index :data_sets, [:x_unit_id]
    add_index :data_sets, [:activity_id]

    create_table :data_set_graphs do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :data_set_id
      t.integer  :predefined_graph_pane_id
    end
    add_index :data_set_graphs, [:data_set_id]
    add_index :data_set_graphs, [:predefined_graph_pane_id]
  end

  def self.down
    drop_table :data_sets
    drop_table :data_set_graphs
  end
end
