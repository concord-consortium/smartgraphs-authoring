class AddCcProjectNameToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :cc_project_name, :string, :default => "Smartgraphs"
  end

  def self.down
    remove_column :activities, :cc_project_name
  end
end
