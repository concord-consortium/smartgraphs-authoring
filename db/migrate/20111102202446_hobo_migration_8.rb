class HoboMigration8 < ActiveRecord::Migration
  def self.up
    create_table :units do |t|
      t.string   :name
      t.string   :abbreviation
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :units
  end
end
