class DataSetPredefinedGraph < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :predefined_graph_pane

  fields do
    in_legend :boolean, :default => false
    timestamps
  end

  attr_accessible :in_legend, :data_set, :data_set_id

  belongs_to :data_set
  belongs_to :predefined_graph_pane

end
