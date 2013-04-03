class RenameLabelsToGraphLabels < ActiveRecord::Migration
  def self.up
    rename_table :labels, :graph_labels

    remove_index :graph_labels, :name => :index_labels_on_label_set_id rescue ActiveRecord::StatementInvalid
    add_index :graph_labels, [:label_set_id]
  end

  def self.down
    rename_table :graph_labels, :labels

    remove_index :labels, :name => :index_graph_labels_on_label_set_id rescue ActiveRecord::StatementInvalid
    add_index :labels, [:label_set_id]
  end
end
