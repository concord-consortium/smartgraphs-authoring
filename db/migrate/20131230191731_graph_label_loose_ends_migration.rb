class GraphLabelLooseEndsMigration < ActiveRecord::Migration
  def self.up
    change_column :graph_labels, :parent_type, :string, :limit => 255, :default => nil
  end

  def self.down
    change_column :graph_labels, :parent_type, :string, :default => "LabelSet"
  end
end
