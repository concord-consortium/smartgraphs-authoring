class HoboMigration7 < ActiveRecord::Migration
  def self.up
    create_table :predefined_graph_panes do |t|
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
    end
  end

  def self.down
    drop_table :predefined_graph_panes
  end
end
