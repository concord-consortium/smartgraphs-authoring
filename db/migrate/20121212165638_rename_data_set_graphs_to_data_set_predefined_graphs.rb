class RenameDataSetGraphsToDataSetPredefinedGraphs < ActiveRecord::Migration
  def self.up
    rename_table :data_set_graphs, :data_set_predefined_graphs

    remove_index :data_set_predefined_graphs, :name => :index_data_set_graphs_on_data_set_id rescue ActiveRecord::StatementInvalid
    remove_index :data_set_predefined_graphs, :name => :index_data_set_graphs_on_predefined_graph_pane_id rescue ActiveRecord::StatementInvalid
    add_index :data_set_predefined_graphs, [:data_set_id]
    add_index :data_set_predefined_graphs, [:predefined_graph_pane_id]
  end

  def self.down
    rename_table :data_set_predefined_graphs, :data_set_graphs

    remove_index :data_set_graphs, :name => :index_data_set_predefined_graphs_on_data_set_id rescue ActiveRecord::StatementInvalid
    remove_index :data_set_graphs, :name => :index_data_set_predefined_graphs_on_predefined_graph_pane_id rescue ActiveRecord::StatementInvalid
    add_index :data_set_graphs, [:data_set_id]
    add_index :data_set_graphs, [:predefined_graph_pane_id]
  end
end
