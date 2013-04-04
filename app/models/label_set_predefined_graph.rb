class LabelSetPredefinedGraph < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :predefined_graph_pane

  belongs_to :label_set
  belongs_to :predefined_graph_pane

  fields do
    timestamps
  end
end
