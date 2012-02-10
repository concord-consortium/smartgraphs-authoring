class M < ActiveRecord::Migration
  def self.up
    rename_column :multiple_choice_choices, :choice_name, :name
  end

  def self.down
    rename_column :multiple_choice_choices, :name, :choice_name
  end
end
