class AnnotationInclusion < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    timestamps
  end

  belongs_to :included_graph, :class_name => "PredictionGraphPane", :index => "included_graph_idx"
  belongs_to :including_graph, :polymorphic => true, :index => "including_graph_idx"

  acts_as_list

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end
