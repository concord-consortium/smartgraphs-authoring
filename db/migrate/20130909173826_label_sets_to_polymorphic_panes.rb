class LabelSetsToPolymorphicPanes < ActiveRecord::Migration
  def self.up
    rename_table :label_set_predefined_graphs, :label_set_graph_panes

    rename_column :label_set_graph_panes, :predefined_graph_pane_id, :pane_id
    add_column :label_set_graph_panes, :pane_type, :string, :default => 'PredefinedGraphPane'

    remove_index :label_set_graph_panes, :name => :index_label_set_predefined_graphs_on_label_set_id rescue ActiveRecord::StatementInvalid
    remove_index :label_set_graph_panes, :name => :index_label_set_predefined_graphs_on_predefined_graph_pane_id rescue ActiveRecord::StatementInvalid
    add_index :label_set_graph_panes, [:label_set_id]
    add_index :label_set_graph_panes, [:pane_type, :pane_id]
  end

  def self.down
    rename_column :label_set_graph_panes, :pane_id, :predefined_graph_pane_id
    remove_column :label_set_graph_panes, :pane_type

    rename_table :label_set_graph_panes, :label_set_predefined_graphs

    remove_index :label_set_predefined_graphs, :name => :index_label_set_graph_panes_on_label_set_id rescue ActiveRecord::StatementInvalid
    remove_index :label_set_predefined_graphs, :name => :index_label_set_graph_panes_on_pane_type_and_pane_id rescue ActiveRecord::StatementInvalid
    add_index :label_set_predefined_graphs, [:label_set_id]
    add_index :label_set_predefined_graphs, [:predefined_graph_pane_id]
  end
end
