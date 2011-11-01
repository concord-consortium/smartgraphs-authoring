class HoboMigration6 < ActiveRecord::Migration
  def self.up
    add_column :image_panes, :license, :string
    add_column :image_panes, :attribution, :string
  end

  def self.down
    remove_column :image_panes, :license
    remove_column :image_panes, :attribution
  end
end
