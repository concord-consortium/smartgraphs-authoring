class AddShowFullImageToImagePanes < ActiveRecord::Migration
  def self.up
    add_column :image_panes, :show_full_image, :boolean
  end

  def self.down
    remove_column :image_panes, :show_full_image
  end
end
