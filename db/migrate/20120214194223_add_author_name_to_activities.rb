class AddAuthorNameToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :author_name, :string
  end

  def self.down
    remove_column :activities, :author_name
  end
end
