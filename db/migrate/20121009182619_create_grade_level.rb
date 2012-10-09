class CreateGradeLevel < ActiveRecord::Migration
  def self.up
    change_column :activities, :publication_status, :string, :limit => 255, :default => :private
  end

  def self.down
    change_column :activities, :publication_status, :string, :default => "private"
  end
end
