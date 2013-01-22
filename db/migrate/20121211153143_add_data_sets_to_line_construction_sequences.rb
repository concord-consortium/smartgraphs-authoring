class AddDataSetsToLineConstructionSequences < ActiveRecord::Migration
  def self.up
    add_column :line_construction_sequences, :data_set_id, :integer

    add_index :line_construction_sequences, [:data_set_id]
  end

  def self.down
    remove_column :line_construction_sequences, :data_set_id

    remove_index :line_construction_sequences, :name => :index_line_construction_sequences_on_data_set_id rescue ActiveRecord::StatementInvalid
  end
end
