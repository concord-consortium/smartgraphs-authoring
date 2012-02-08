class HoboMigration30 < ActiveRecord::Migration
  def self.up
    create_table :multiple_choice_sequences do |t|
      t.text     :initial_prompt
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :multiple_choice_sequences
  end
end
