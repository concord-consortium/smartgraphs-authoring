class DataSetGraph < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  include SgPermissions
  sg_parent :predefined_graph_pane
  
  fields do
    timestamps
  end

  belongs_to :data_set
  belongs_to :predefined_graph_pane

end
