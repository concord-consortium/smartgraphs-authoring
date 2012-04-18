class AddPointConstraints < ActiveRecord::Migration
  def self.up
    add_column :slope_tool_sequences, :point_constraints, :string, :default => :any
    remove_column :slope_tool_sequences, :student_selects_points
    remove_column :slope_tool_sequences, :student_must_select_endpoints_of_range
    remove_column :slope_tool_sequences, :selected_points_must_be_adjacent
    change_column :slope_tool_sequences, :case_type, :string, :limit => 255, :default => :case_a
  end

  def self.down
    remove_column :slope_tool_sequences, :point_constraints
    add_column :slope_tool_sequences, :student_selects_points, :boolean, :default => true
    add_column :slope_tool_sequences, :student_must_select_endpoints_of_range, :boolean, :default => false
    add_column :slope_tool_sequences, :selected_points_must_be_adjacent, :boolean, :default => false
    change_column :slope_tool_sequences, :case_type, :string, :default => "A"
  end
end
