class PredefinedGraphPaneHasGraphLabel < ActiveRecord::Migration
  def self.up
    add_column :graph_labels, :predefined_graph_pane_id, :integer

    add_index :graph_labels, [:predefined_graph_pane_id]
  end

  def self.down
    remove_column :graph_labels, :predefined_graph_pane_id

    remove_index :graph_labels, :name => :index_graph_labels_on_predefined_graph_pane_id rescue ActiveRecord::StatementInvalid
  end
end
