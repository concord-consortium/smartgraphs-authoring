class HoboMigration22 < ActiveRecord::Migration
  def self.up
    create_table :constructed_responses do |t|
      t.string   :title
      t.text     :initial_content
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :constructed_response_sequence_id
      t.integer  :position
    end
    add_index :constructed_responses, [:constructed_response_sequence_id]
  end

  def self.down
    drop_table :constructed_responses
  end
end
