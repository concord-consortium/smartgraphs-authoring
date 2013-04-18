class AddAnimationMarkedCoordinate < ActiveRecord::Migration
  def self.up
    create_table :animation_marked_coordinates do |t|
      t.float    :coordinate
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :animation_id
    end
    add_index :animation_marked_coordinates, [:animation_id]

    remove_column :animations, :marked_coordinates
  end

  def self.down
    add_column :animations, :marked_coordinates, :text

    drop_table :animation_marked_coordinates
  end
end
