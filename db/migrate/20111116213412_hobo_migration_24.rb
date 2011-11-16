class HoboMigration24 < ActiveRecord::Migration
  def self.up
    create_table :point_circle_visual_prompts do |t|
      t.string   :name
      t.float    :point_x
      t.float    :point_y
      t.string   :color
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :point_circle_visual_prompts
  end
end
