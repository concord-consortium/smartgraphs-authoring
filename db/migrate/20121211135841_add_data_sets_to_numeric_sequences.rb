class AddDataSetsToNumericSequences < ActiveRecord::Migration
  def self.up
    add_column :numeric_sequences, :data_set_id, :integer

    add_index :numeric_sequences, [:data_set_id]
  end

  def self.down
    remove_column :numeric_sequences, :data_set_id

    remove_index :numeric_sequences, :name => :index_numeric_sequences_on_data_set_id rescue ActiveRecord::StatementInvalid
  end
end
