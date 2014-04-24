class AddIsCopyingToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :is_copying, :boolean, :default => false
  end

  def self.down
    remove_column :activities, :is_copying
  end
end
