class AddLinkedAnimationPanes < ActiveRecord::Migration
  def self.up
    create_table :linked_animation_panes do |t|
      t.string   :title
      t.string   :x_label
      t.float    :x_min
      t.float    :x_max
      t.float    :x_ticks
      t.float    :x_precision, :default => 0.1
      t.string   :y_label
      t.float    :y_min
      t.float    :y_max
      t.float    :y_ticks
      t.float    :y_precision, :default => 0.1
      t.boolean  :show_cross_hairs, :default => false
      t.boolean  :show_graph_grid, :default => false
      t.boolean  :show_tool_tip_coords, :default => false
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :linked_animation_panes
  end
end
