class HoboMigration18 < ActiveRecord::Migration
  def self.up
    add_column :sequence_hints, :numeric_sequence_id, :integer

    add_index :sequence_hints, [:numeric_sequence_id]
  end

  def self.down
    remove_column :sequence_hints, :numeric_sequence_id

    remove_index :sequence_hints, :name => :index_sequence_hints_on_numeric_sequence_id rescue ActiveRecord::StatementInvalid
  end
end
