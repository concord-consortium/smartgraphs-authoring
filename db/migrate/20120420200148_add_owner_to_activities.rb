class AddOwnerToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :owner_id, :integer

    add_index :activities, [:owner_id]
  end

  def self.down
    remove_column :activities, :owner_id

    remove_index :activities, :name => :index_activities_on_owner_id rescue ActiveRecord::StatementInvalid
  end
end
