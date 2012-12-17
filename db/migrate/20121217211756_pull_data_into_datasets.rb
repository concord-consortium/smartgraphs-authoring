class PullDataIntoDatasets < ActiveRecord::Migration
  def self.up
    DataSet.convertAllGraphPanes();
  end

  def self.down
  end
end
