class AddAssociationsToAnimations < ActiveRecord::Migration
  def self.up
    add_column :animations, :activity_id, :integer
    add_column :animations, :data_set_id, :integer

    add_index :animations, [:activity_id]
    add_index :animations, [:data_set_id]
  end

  def self.down
    remove_column :animations, :activity_id
    remove_column :animations, :data_set_id

    remove_index :animations, :name => :index_animations_on_activity_id rescue ActiveRecord::StatementInvalid
    remove_index :animations, :name => :index_animations_on_data_set_id rescue ActiveRecord::StatementInvalid
  end
end
