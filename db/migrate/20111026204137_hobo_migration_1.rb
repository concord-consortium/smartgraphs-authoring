class HoboMigration1 < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :pages do |t|
      t.string   :name
      t.text     :text
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :activity_id
    end
    add_index :pages, [:activity_id]
  end

  def self.down
    drop_table :activities
    drop_table :pages
  end
end
