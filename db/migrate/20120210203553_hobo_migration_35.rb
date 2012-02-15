class HoboMigration35 < ActiveRecord::Migration
  def self.up
    add_column :multiple_choice_choices, :correct, :boolean
  end

  def self.down
    remove_column :multiple_choice_choices, :correct
  end
end
