class HoboMigration3 < ActiveRecord::Migration
  def self.up
    create_table :json_activities do |t|
      t.string   :name
      t.text     :json
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :json_activities
  end
end
