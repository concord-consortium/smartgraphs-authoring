class DataSetPanes < ActiveRecord::Migration
  def self.up
    rename_table :data_set_predefined_graphs, :data_set_panes

    rename_column :data_set_panes, :predefined_graph_pane_id, :pane_id
    add_column :data_set_panes, :pane_type, :string, :default => 'PredefinedGraphPane'

    remove_index :data_set_panes, :name => :index_data_set_predefined_graphs_on_data_set_id rescue ActiveRecord::StatementInvalid
    remove_index :data_set_panes, :name => :index_data_set_predefined_graphs_on_predefined_graph_pane_id rescue ActiveRecord::StatementInvalid
    add_index :data_set_panes, [:data_set_id]
    add_index :data_set_panes, [:pane_type, :pane_id]
  end

  def self.down
    rename_column :data_set_panes, :pane_id, :predefined_graph_pane_id
    remove_column :data_set_panes, :pane_type

    rename_table :data_set_panes, :data_set_predefined_graphs

    remove_index :data_set_predefined_graphs, :name => :index_data_set_panes_on_data_set_id rescue ActiveRecord::StatementInvalid
    remove_index :data_set_predefined_graphs, :name => :index_data_set_panes_on_pane_type_and_pane_id rescue ActiveRecord::StatementInvalid
    add_index :data_set_predefined_graphs, [:data_set_id]
    add_index :data_set_predefined_graphs, [:predefined_graph_pane_id]
  end
end
