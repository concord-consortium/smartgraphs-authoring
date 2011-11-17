class HoboMigration23 < ActiveRecord::Migration
  def self.up
    drop_table :constructed_responses

    add_column :constructed_response_sequences, :initial_content, :text
  end

  def self.down
    remove_column :constructed_response_sequences, :initial_content

    create_table "constructed_responses", :force => true do |t|
      t.string   "title"
      t.text     "initial_content"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "constructed_response_sequence_id"
      t.integer  "position"
    end

    add_index "constructed_responses", ["constructed_response_sequence_id"], :name => "index_constructed_responses_on_constructed_response_sequence_id"
  end
end
