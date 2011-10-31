class HoboMigration4 < ActiveRecord::Migration
  def self.up
    create_table :image_panes do |t|
      t.string   :name
      t.string   :url
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :page_panes do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :page_id
      t.integer  :pane_id
      t.string   :pane_type
    end
    add_index :page_panes, [:page_id]
    add_index :page_panes, [:pane_type, :pane_id]
  end

  def self.down
    drop_table :image_panes
    drop_table :page_panes
  end
end
