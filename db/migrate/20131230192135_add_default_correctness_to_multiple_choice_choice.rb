class AddDefaultCorrectnessToMultipleChoiceChoice < ActiveRecord::Migration
  def self.up
    change_column :multiple_choice_choices, :correct, :boolean, :default => false
  end

  def self.down
    change_column :multiple_choice_choices, :correct, :boolean
  end
end
