class GraphLabel < ActiveRecord::Base

  hobo_model # Don't put anything above this
  include SgMarshal
  include SgPermissions
  sg_parent :label_set

  belongs_to :label_set

  belongs_to :predefined_graph_pane

  fields do
    text :string, :required => true
    x_coord :float, :required => true
    y_coord :float, :required => true
    timestamps
  end

  def field_order
    "text, x_coord, y_coord"
  end

  def to_hash
    {
      'text' => text,
      'point' => [x_coord, y_coord]
    }
  end
end
