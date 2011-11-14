class HoboMigration20 < ActiveRecord::Migration
  def self.up
    create_table :sensor_graph_panes do |t|
      t.string   :title
      t.string   :y_label
      t.float    :y_min
      t.float    :y_max
      t.float    :y_ticks
      t.string   :x_label
      t.float    :x_min
      t.float    :x_max
      t.float    :x_ticks
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :y_unit_id
      t.integer  :x_unit_id
    end
    add_index :sensor_graph_panes, [:y_unit_id]
    add_index :sensor_graph_panes, [:x_unit_id]
  end

  def self.down
    drop_table :sensor_graph_panes
  end
end
