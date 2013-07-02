class AddDerivativeOfAndPiecewiseLinearToDataSet < ActiveRecord::Migration
  def self.up
    add_column :data_sets, :piecewise_linear, :boolean, :default => false
    add_column :data_sets, :derivative_of_id, :integer

    add_index :data_sets, [:derivative_of_id]
  end

  def self.down
    remove_column :data_sets, :piecewise_linear
    remove_column :data_sets, :derivative_of_id

    remove_index :data_sets, :name => :index_data_sets_on_derivative_of_id rescue ActiveRecord::StatementInvalid
  end
end
