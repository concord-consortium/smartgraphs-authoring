class HoboMigration15 < ActiveRecord::Migration
  def self.up
    create_table :range_visual_prompts do |t|
      t.string   :name
      t.float    :x_min
      t.float    :x_max
      t.string   :color
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :text_hint_prompts do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :text_hint_id
      t.integer  :prompt_id
      t.string   :prompt_type
    end
    add_index :text_hint_prompts, [:text_hint_id]
    add_index :text_hint_prompts, [:prompt_type, :prompt_id], :name => 'index_prompts'
  end

  def self.down
    drop_table :range_visual_prompts
    drop_table :text_hint_prompts
  end
end
