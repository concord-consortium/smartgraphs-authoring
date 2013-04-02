class AddLabels < ActiveRecord::Migration
  def self.up
    create_table :labels do |t|
      t.integer  :label_set_id
      t.string   :text, :required => true
      t.float    :x_coord, :required => true
      t.float    :y_coord, :required => true
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :labels, [:label_set_id]
  end

  def self.down
    drop_table :labels
  end
end
