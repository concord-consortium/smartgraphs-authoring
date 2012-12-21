class AddXyLabelsToTablePanes < ActiveRecord::Migration
  def self.up
    add_column :table_panes, :x_label, :string
    add_column :table_panes, :y_label, :string
  end

  def self.down
    remove_column :table_panes, :x_label
    remove_column :table_panes, :y_label
  end
end
