class DataSetPredictionGraph < ActiveRecord::Base

  hobo_model # Don't put anything above this

  include SgPermissions
  sg_parent :prediction_graph_pane

  fields do
    in_legend :boolean, :default => false
    timestamps
  end

  belongs_to :data_set
  belongs_to :prediction_graph_pane

end
