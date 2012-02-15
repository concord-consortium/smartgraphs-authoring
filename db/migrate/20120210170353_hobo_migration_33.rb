class HoboMigration33 < ActiveRecord::Migration
  def self.up
    create_table :multiple_choice_hints do |t|
      t.string   :name
      t.text     :hint_text
      t.integer  :position
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_column :multiple_choice_sequences, :give_up, :text
    add_column :multiple_choice_sequences, :confirm_correct, :text
  end

  def self.down
    remove_column :multiple_choice_sequences, :give_up
    remove_column :multiple_choice_sequences, :confirm_correct

    drop_table :multiple_choice_hints
  end
end
