class CreateActivityGradeLevels < ActiveRecord::Migration
  def self.up
    create_table :activity_grade_levels do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :activity_id
      t.integer  :grade_level_id
    end
    add_index :activity_grade_levels, [:activity_id]
    add_index :activity_grade_levels, [:grade_level_id]

    create_table :grade_levels do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    change_column :activities, :publication_status, :string, :limit => 255, :default => :private
  end

  def self.down
    change_column :activities, :publication_status, :string, :default => "private"

    drop_table :activity_grade_levels
    drop_table :grade_levels
  end
end
