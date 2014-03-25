class AddErrorsToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :errors, :text
  end

  def self.down
    remove_column :activities, :errors
  end
end
