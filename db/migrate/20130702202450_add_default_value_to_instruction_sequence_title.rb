class AddDefaultValueToInstructionSequenceTitle < ActiveRecord::Migration
  def self.up
    change_column :instruction_sequences, :title, :string, :limit => 255, :default => "new instruction sequence"
  end

  def self.down
    change_column :instruction_sequences, :title, :string, :default => ""
  end
end
