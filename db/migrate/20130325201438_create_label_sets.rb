class CreateLabelSets < ActiveRecord::Migration
  def self.up
    create_table :label_sets do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :activity_id
    end
    add_index :label_sets, [:activity_id]
  end

  def self.down
    drop_table :label_sets
  end
end
