class AddLineConstructionSequences < ActiveRecord::Migration
  def self.up
    create_table :line_construction_sequences do |t|
      t.string   :name, :default => "new line construction"
      t.float    :slope, :default => 1
      t.float    :slope_tolerance, :default => 0
      t.float    :y_intercept, :default => 0
      t.float    :y_intercept_tolerance, :default => 0.1
      t.boolean  :show_cross_hairs, :default => true
      t.boolean  :show_tool_tip_coords, :default => false
      t.boolean  :show_graph_grid, :default => true
      t.text     :intial_prompt
      t.text     :confirm_correct
      t.text     :slope_incorrect
      t.text     :y_intercept_incorrect
      t.text     :all_incorrect
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :line_construction_sequences
  end
end
