class CreateSlopeToolSequence < ActiveRecord::Migration
  def self.up
    create_table :slope_tool_sequences do |t|
      t.boolean  :first_question_is_slope_question, :default => true
      t.boolean  :student_selects_points, :default => true
      t.text     :first_question
      t.boolean  :student_must_select_endpoints_of_range, :default => false
      t.string   :slope_variable_name
      t.float    :x_min, :default => 0
      t.float    :y_min, :default => 0
      t.float    :x_max, :default => 10
      t.float    :y_max, :default => 10
      t.boolean  :selected_points_must_be_adjacent, :default => false
      t.float    :tolerance, :default => 0.1
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :slope_tool_sequences
  end
end
