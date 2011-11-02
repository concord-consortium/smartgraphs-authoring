class HoboMigration9 < ActiveRecord::Migration
  def self.up
    add_column :predefined_graph_panes, :y_unit_id, :integer
    add_column :predefined_graph_panes, :x_unit_id, :integer

    add_index :predefined_graph_panes, [:y_unit_id]
    add_index :predefined_graph_panes, [:x_unit_id]
  end

  def self.down
    remove_column :predefined_graph_panes, :y_unit_id
    remove_column :predefined_graph_panes, :x_unit_id

    remove_index :predefined_graph_panes, :name => :index_predefined_graph_panes_on_y_unit_id rescue ActiveRecord::StatementInvalid
    remove_index :predefined_graph_panes, :name => :index_predefined_graph_panes_on_x_unit_id rescue ActiveRecord::StatementInvalid
  end
end
