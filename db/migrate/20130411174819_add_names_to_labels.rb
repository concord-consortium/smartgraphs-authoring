class AddNamesToLabels < ActiveRecord::Migration
  def self.up
    add_column :graph_labels, :name, :string, :required => false
  end

  def self.down
    remove_column :graph_labels, :name
  end
end
