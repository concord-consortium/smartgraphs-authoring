class AddLabelSetPredefinedGraphs < ActiveRecord::Migration
  def self.up
    create_table :label_set_predefined_graphs do |t|
      t.integer  :label_set_id
      t.integer  :predefined_graph_pane_id
      t.datetime :created_at
      t.datetime :updated_at
    end
    add_index :label_set_predefined_graphs, [:label_set_id]
    add_index :label_set_predefined_graphs, [:predefined_graph_pane_id]
  end

  def self.down
    drop_table :label_set_predefined_graphs
  end
end
