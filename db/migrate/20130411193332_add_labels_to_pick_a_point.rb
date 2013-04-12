class AddLabelsToPickAPoint < ActiveRecord::Migration
  def self.up
    add_column :graph_labels, :pick_a_point_sequence_id, :integer

    add_index :graph_labels, [:pick_a_point_sequence_id]
  end

  def self.down
    remove_column :graph_labels, :pick_a_point_sequence_id

    remove_index :graph_labels, :name => :index_graph_labels_on_pick_a_point_sequence_id rescue ActiveRecord::StatementInvalid
  end
end
