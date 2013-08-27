class AddEmptyPanes < ActiveRecord::Migration
  def self.up
    create_table :empty_panes do |t|
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def self.down
    drop_table :empty_panes
  end
end
