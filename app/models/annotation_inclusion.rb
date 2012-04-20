class AnnotationInclusion < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include StandardPermissions

  fields do
    timestamps
  end

  belongs_to :included_graph, :class_name => "PredictionGraphPane", :index => "included_graph_idx"
  belongs_to :including_graph, :polymorphic => true, :index => "including_graph_idx"

  acts_as_list

end
