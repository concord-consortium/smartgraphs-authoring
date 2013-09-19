class AddMinMaxXToAnimationPanes < ActiveRecord::Migration
  def self.up
    add_column :animation_panes, :spec_min_x, :float
    add_column :animation_panes, :spec_max_x, :float
  end

  def self.down
    remove_column :animation_panes, :spec_min_x
    remove_column :animation_panes, :spec_max_x
  end
end
