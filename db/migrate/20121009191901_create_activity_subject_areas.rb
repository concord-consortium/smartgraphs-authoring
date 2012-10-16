class CreateActivitySubjectAreas < ActiveRecord::Migration
  def self.up
    create_table :activity_subject_areas do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :activity_id
      t.integer  :subject_area_id
    end
    add_index :activity_subject_areas, [:activity_id]
    add_index :activity_subject_areas, [:subject_area_id]

    change_column :activities, :publication_status, :string, :limit => 255, :default => :private
  end

  def self.down
    change_column :activities, :publication_status, :string, :default => "private"

    drop_table :activity_subject_areas
  end
end
