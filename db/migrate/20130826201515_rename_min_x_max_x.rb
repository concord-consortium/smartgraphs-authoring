class RenameMinXMaxX < ActiveRecord::Migration
  def self.up
    rename_column :animation_panes, :spec_min_x, :specify_start_x
    rename_column :animation_panes, :spec_max_x, :specify_end_x
  end

  def self.down
    rename_column :animation_panes, :specify_start_x, :spec_min_x
    rename_column :animation_panes, :specify_end_x, :spec_max_x
  end
end
