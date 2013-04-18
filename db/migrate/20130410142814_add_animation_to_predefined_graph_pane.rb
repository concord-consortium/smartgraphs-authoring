class AddAnimationToPredefinedGraphPane < ActiveRecord::Migration
  def self.up
    add_column :predefined_graph_panes, :animation_id, :integer

    add_index :predefined_graph_panes, [:animation_id]
  end

  def self.down
    remove_column :predefined_graph_panes, :animation_id

    remove_index :predefined_graph_panes, :name => :index_predefined_graph_panes_on_animation_id rescue ActiveRecord::StatementInvalid
  end
end
