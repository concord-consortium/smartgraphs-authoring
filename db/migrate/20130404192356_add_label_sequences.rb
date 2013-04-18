class AddLabelSequences < ActiveRecord::Migration
  def self.up
    create_table :label_sequences do |t|
      t.string   :title, :default => "New label sequence"
      t.text     :text
      t.integer  :label_count, :default => 1
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :label_set_id
    end
    add_index :label_sequences, [:label_set_id]
  end

  def self.down
    drop_table :label_sequences
  end
end
