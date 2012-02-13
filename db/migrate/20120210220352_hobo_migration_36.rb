class HoboMigration36 < ActiveRecord::Migration
  def self.up
    add_column :multiple_choice_choices, :feedback, :text
  end

  def self.down
    remove_column :multiple_choice_choices, :feedback
  end
end
