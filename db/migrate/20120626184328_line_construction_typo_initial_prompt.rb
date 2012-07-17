class LineConstructionTypoInitialPrompt < ActiveRecord::Migration
  def self.up
    rename_column :line_construction_sequences, :intial_prompt, :initial_prompt
  end

  def self.down
    rename_column :line_construction_sequences, :initial_prompt, :intial_prompt
  end
end
