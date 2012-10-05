class HoboMigration16 < ActiveRecord::Migration
  def self.up
    create_table :confirm_correct_prompts do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :pick_a_point_sequence_id
      t.integer  :prompt_id
      t.string   :prompt_type
    end
    add_index :confirm_correct_prompts, [:pick_a_point_sequence_id], :name => 'index_confirm_correct_pick_a_points'
    add_index :confirm_correct_prompts, [:prompt_type, :prompt_id],  :name => 'index_confirm_correct_prompts'

    create_table :give_up_prompts do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :pick_a_point_sequence_id
      t.integer  :prompt_id
      t.string   :prompt_type
    end
    add_index :give_up_prompts, [:pick_a_point_sequence_id], :name  => 'index_give_up_pick_a_points'
    add_index :give_up_prompts, [:prompt_type, :prompt_id],  :name  => 'index_give_up_prompts'

    create_table :initial_prompt_prompts do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :pick_a_point_sequence_id
      t.integer  :prompt_id
      t.string   :prompt_type
    end
    add_index :initial_prompt_prompts, [:pick_a_point_sequence_id], :name => 'index_initial_prompt_pick_a_points'
    add_index :initial_prompt_prompts, [:prompt_type, :prompt_id], :name => 'index_initial_prompt_prompts'
  end

  def self.down
    drop_table :confirm_correct_prompts
    drop_table :give_up_prompts
    drop_table :initial_prompt_prompts
  end
end
