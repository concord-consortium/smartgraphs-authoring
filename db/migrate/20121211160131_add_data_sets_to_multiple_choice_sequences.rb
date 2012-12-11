class AddDataSetsToMultipleChoiceSequences < ActiveRecord::Migration
  def self.up
    add_column :multiple_choice_sequences, :data_set_id, :integer

    add_index :multiple_choice_sequences, [:data_set_id]
  end

  def self.down
    remove_column :multiple_choice_sequences, :data_set_id

    remove_index :multiple_choice_sequences, :name => :index_multiple_choice_sequences_on_data_set_id rescue ActiveRecord::StatementInvalid
  end
end
