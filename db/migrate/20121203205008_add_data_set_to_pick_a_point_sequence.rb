class AddDataSetToPickAPointSequence < ActiveRecord::Migration
  def self.up
    add_column :pick_a_point_sequences, :data_set_id, :integer

    add_index :pick_a_point_sequences, [:data_set_id]
  end

  def self.down
    remove_column :pick_a_point_sequences, :data_set_id

    remove_index :pick_a_point_sequences, :name => :index_pick_a_point_sequences_on_data_set_id rescue ActiveRecord::StatementInvalid
  end
end
