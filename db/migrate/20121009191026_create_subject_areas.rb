class CreateSubjectAreas < ActiveRecord::Migration
  def self.up
    create_table :subject_areas do |t|
      t.string   :name
      t.datetime :created_at
      t.datetime :updated_at
    end

    change_column :activities, :publication_status, :string, :limit => 255, :default => :private
  end

  def self.down
    change_column :activities, :publication_status, :string, :default => "private"

    drop_table :subject_areas
  end
end
