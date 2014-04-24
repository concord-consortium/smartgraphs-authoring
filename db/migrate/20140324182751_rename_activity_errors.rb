class RenameActivityErrors < ActiveRecord::Migration
  def self.up
    rename_column :activities, :errors, :activity_errors
  end

  def self.down
    rename_column :activities, :activity_errors, :errors
  end
end
