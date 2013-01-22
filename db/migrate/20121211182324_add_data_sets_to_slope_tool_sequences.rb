class AddDataSetsToSlopeToolSequences < ActiveRecord::Migration
  def self.up
    add_column :slope_tool_sequences, :data_set_id, :integer

    add_index :slope_tool_sequences, [:data_set_id]
  end

  def self.down
    remove_column :slope_tool_sequences, :data_set_id

    remove_index :slope_tool_sequences, :name => :index_slope_tool_sequences_on_data_set_id rescue ActiveRecord::StatementInvalid
  end
end
