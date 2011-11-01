class HoboMigration5 < ActiveRecord::Migration
  def self.up
    add_column :page_panes, :position, :integer
  end

  def self.down
    remove_column :page_panes, :position
  end
end
