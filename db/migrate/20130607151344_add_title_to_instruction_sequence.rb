class AddTitleToInstructionSequence < ActiveRecord::Migration
  def self.up
    add_column :instruction_sequences, :title, :string, :limit => 255, :default => ""
  end

  def self.down
    remove_column :instruction_sequences, :title, :string
  end
end
