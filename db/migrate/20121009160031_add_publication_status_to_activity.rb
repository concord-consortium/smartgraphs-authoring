class AddPublicationStatusToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :publication_status, :string, :default => :private
  end

  def self.down
    remove_column :activities, :publication_status
  end
end
