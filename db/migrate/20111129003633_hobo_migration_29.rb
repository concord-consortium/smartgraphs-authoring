class HoboMigration29 < ActiveRecord::Migration
  def self.up
    create_table :annotation_inclusions do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :included_graph_id
      t.integer  :including_graph_id
      t.string   :including_graph_type
      t.integer  :position
    end
    add_index :annotation_inclusions, [:included_graph_id], :name => 'included_graph_idx'
    add_index :annotation_inclusions, [:including_graph_type, :including_graph_id], :name => 'including_graph_idx'
  end

  def self.down
    drop_table :annotation_inclusions
  end
end
