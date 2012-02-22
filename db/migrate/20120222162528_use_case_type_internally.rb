class UseCaseTypeInternally < ActiveRecord::Migration
  def self.up
    add_column :slope_tool_sequences, :case_type, :string, :default => "A"
    remove_column :slope_tool_sequences, :first_question_is_slope_question
  end

  def self.down
    remove_column :slope_tool_sequences, :case_type
    add_column :slope_tool_sequences, :first_question_is_slope_question, :boolean, :default => true
  end
end
