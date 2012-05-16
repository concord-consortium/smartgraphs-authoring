class AddDefaultSlopeName < ActiveRecord::Migration
  def self.up
    change_column :slope_tool_sequences, :slope_variable_name, :string, :limit => 255, :default => "slope"
  end

  def self.down
    change_column :slope_tool_sequences, :slope_variable_name, :string
  end
end
