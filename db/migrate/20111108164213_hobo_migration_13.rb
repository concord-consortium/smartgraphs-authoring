class HoboMigration13 < ActiveRecord::Migration
  def self.up
    remove_index :page_sequences, [:sequence_type, :sequence_id]

    remove_column :page_sequences, :position

    add_index :page_sequences, [:sequence_type, :sequence_id], :name => 'index_sequences'
  end

  def self.down
    remove_index :page_sequences, :name => 'index_sequences'

    add_column :page_sequences, :position, :integer

    add_index :page_sequences, [:sequence_type, :sequence_id]
  end
end
