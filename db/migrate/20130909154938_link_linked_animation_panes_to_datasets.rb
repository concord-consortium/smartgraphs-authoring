class LinkLinkedAnimationPanesToDatasets < ActiveRecord::Migration
  def self.up
    change_column :data_set_panes, :pane_type, :string, :limit => 255, :default => nil
  end

  def self.down
    change_column :data_set_panes, :pane_type, :string, :default => "PredefinedGraphPane"
  end
end
