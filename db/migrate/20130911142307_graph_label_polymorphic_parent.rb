class GraphLabelPolymorphicParent < ActiveRecord::Migration
  def self.up
    rename_column :graph_labels, :label_set_id, :parent_id
    add_column :graph_labels, :parent_type, :string, :default => 'LabelSet'

    GraphLabel.reset_column_information
    GraphLabel.all.each do |gl|
      if gl.predefined_graph_pane_id
        gl.parent_id = gl.predefined_graph_pane_id
        gl.parent_type = 'PredefinedGraphPane'
        gl.save
      end
    end

    remove_column :graph_labels, :predefined_graph_pane_id

    remove_index :graph_labels, :name => :index_graph_labels_on_label_set_id rescue ActiveRecord::StatementInvalid
    remove_index :graph_labels, :name => :index_graph_labels_on_predefined_graph_pane_id rescue ActiveRecord::StatementInvalid
    add_index :graph_labels, [:parent_type, :parent_id]
  end

  def self.down
    rename_column :graph_labels, :parent_id, :label_set_id
    remove_column :graph_labels, :parent_type
    add_column :graph_labels, :predefined_graph_pane_id, :integer

    remove_index :graph_labels, :name => :index_graph_labels_on_parent_type_and_parent_id rescue ActiveRecord::StatementInvalid
    add_index :graph_labels, [:label_set_id]
    add_index :graph_labels, [:predefined_graph_pane_id]
  end
end
