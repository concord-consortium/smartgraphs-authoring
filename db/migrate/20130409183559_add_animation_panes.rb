class AddAnimationPanes < ActiveRecord::Migration
  def self.up
    create_table :animation_panes do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :animation_id
    end
    add_index :animation_panes, [:animation_id]
  end

  def self.down
    drop_table :animation_panes
  end
end
