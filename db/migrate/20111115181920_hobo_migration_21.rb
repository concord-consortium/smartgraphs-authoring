class HoboMigration21 < ActiveRecord::Migration
  def self.up
    create_table :constructed_response_sequences do |t|
      t.string   :title
      t.text     :initial_prompt
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :constructed_response_sequences
  end
end
