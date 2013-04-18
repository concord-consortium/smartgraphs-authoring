class AddIsForUsersToLabelSets < ActiveRecord::Migration
  def self.up
    add_column :label_sets, :is_for_users, :boolean, :default => false
  end

  def self.down
    remove_column :label_sets, :is_for_users
  end
end
