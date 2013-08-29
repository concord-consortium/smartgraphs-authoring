class AddLinkedAnimations < ActiveRecord::Migration
  def self.up
    create_table :animations_data_sets, :id => false do |t|
      t.integer :animation_id
      t.integer :data_set_id
    end
  end

  def self.down
    drop_table :animations_data_sets
  end
end
