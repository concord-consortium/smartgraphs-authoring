class HoboMigration17 < ActiveRecord::Migration
  def self.up
    create_table :numeric_sequences do |t|
      t.string   :title
      t.text     :initial_prompt
      t.text     :give_up
      t.text     :confirm_correct
      t.float    :correct_answer
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :numeric_sequences
  end
end
