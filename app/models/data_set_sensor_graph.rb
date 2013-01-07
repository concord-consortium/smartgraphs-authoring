class DataSetSensorGraph < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :sensor_graph_pane

  fields do
    in_legend :boolean, :default => false
    timestamps
  end

  attr_accessible :in_legend, :data_set, :data_set_id

  belongs_to :data_set
  belongs_to :sensor_graph_pane
end
