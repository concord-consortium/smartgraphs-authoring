class HoboMigration11 < ActiveRecord::Migration
  def self.up
    create_table :table_panes do |t|
      t.string   :title
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :table_panes
  end
end
