class HoboMigration31 < ActiveRecord::Migration
  def self.up
    create_table :multiple_choice_choices do |t|
      t.string   :choice_name
      t.integer  :position
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :multiple_choice_sequence_id
    end
    add_index :multiple_choice_choices, [:multiple_choice_sequence_id]
  end

  def self.down
    drop_table :multiple_choice_choices
  end
end
