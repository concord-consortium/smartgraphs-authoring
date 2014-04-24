class RenameIsCopyingToPreventConversion < ActiveRecord::Migration
  def self.up
    rename_column :activities, :is_copying, :prevent_conversion
  end

  def self.down
    rename_column :activities, :prevent_conversion, :is_copying
  end
end
