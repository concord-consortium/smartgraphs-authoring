class AddAnimations < ActiveRecord::Migration
  def self.up
    create_table :animations do |t|
      t.string   :name
      t.float    :y_min
      t.float    :y_max
      t.text     :marked_coordinates
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :animations
  end
end
