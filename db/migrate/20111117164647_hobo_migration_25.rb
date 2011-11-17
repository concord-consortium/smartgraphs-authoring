class HoboMigration25 < ActiveRecord::Migration
  def self.up
    create_table :point_axis_line_visual_prompts do |t|
      t.string   :name
      t.float    :point_x
      t.float    :point_y
      t.string   :color
      t.string   :axis
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :point_axis_line_visual_prompts
  end
end
