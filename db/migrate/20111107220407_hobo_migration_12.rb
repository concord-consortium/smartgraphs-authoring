class HoboMigration12 < ActiveRecord::Migration
  def self.up
    create_table :instruction_sequences do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.text   :text
    end

    create_table :page_sequences do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :page_id
      t.integer  :sequence_id
      t.string   :sequence_type
      t.integer  :position
    end
    add_index :page_sequences, [:page_id]
    add_index :page_sequences, [:sequence_type, :sequence_id]
  end

  def self.down
    drop_table :instruction_sequences
    drop_table :page_sequences
  end
end
