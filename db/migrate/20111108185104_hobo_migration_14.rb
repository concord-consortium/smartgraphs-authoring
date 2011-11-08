class HoboMigration14 < ActiveRecord::Migration
  def self.up
    create_table :pick_a_point_sequences do |t|
      t.string   :title
      t.text     :initialPrompt
      t.float    :correctAnswerX
      t.float    :correctAnswerY
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :give_up_hint_id
      t.string   :give_up_hint_type
      t.integer  :confirm_correct_hint_id
      t.string   :confirm_correct_hint_type
    end
    add_index :pick_a_point_sequences, [:give_up_hint_type, :give_up_hint_id], :name => 'index_give_up_hints'
    add_index :pick_a_point_sequences, [:confirm_correct_hint_type, :confirm_correct_hint_id], :name => 'index_confirm_correct_hints'

    create_table :sequence_hints do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :pick_a_point_sequence_id
      t.integer  :hint_id
      t.string   :hint_type
      t.integer  :position
    end
    add_index :sequence_hints, [:pick_a_point_sequence_id]
    add_index :sequence_hints, [:hint_type, :hint_id], :name => 'index_hints'

    create_table :text_hints do |t|
      t.string   :name
      t.text     :text
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :pick_a_point_sequences
    drop_table :sequence_hints
    drop_table :text_hints
  end
end
