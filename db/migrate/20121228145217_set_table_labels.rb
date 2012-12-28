class SetTableLabels < ActiveRecord::Migration
  def self.up
    TablePane.reset_column_information
    TablePane.get_all_labels_from_graph_panes
  end

  def self.down
    TablePane.all.each do |tp|
      tp.x_label = nil
      tp.y_label = nil
      tp.save!
    end
  end
end
