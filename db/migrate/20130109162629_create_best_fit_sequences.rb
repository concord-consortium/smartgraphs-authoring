class CreateBestFitSequences < ActiveRecord::Migration
  def self.up
    create_table :best_fit_sequences do |t|
      t.float    :correct_tolerance, :default => 0.1
      t.float    :close_tolerance, :default => 0.2
      t.integer  :max_attempts, :default => 4
      t.text     :initial_prompt
      t.text     :incorrect_prompt
      t.text     :close_prompt
      t.text     :confirm_correct
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :data_set_id
      t.integer  :learner_data_set_id
    end
    add_index :best_fit_sequences, [:data_set_id]
    add_index :best_fit_sequences, [:learner_data_set_id]
  end

  def self.down
    drop_table :best_fit_sequences
  end
end
