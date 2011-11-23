class PredictionGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title   :string
    y_label :string
    y_min   :float
    y_max   :float
    y_ticks :float
    x_label :string
    x_min   :float
    x_max   :float
    x_ticks :float
    prediction_type  enum_string(:straight_lines, :connecting_points, :continuous_curves)
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#prediction_graph_panes'

  def field_order
    "title, y_label, y_unit, y_min, y_max, y_ticks, x_label, x_unit, x_min, x_max, x_ticks, prediction_type"
  end

  def to_hash
    {
      'type' => 'PredictionGraphPane',
      'title' => title,
      'yLabel' => y_label,
      'yUnits' => y_unit ? y_unit.name : nil,
      'yMin' => y_min,
      'yMax' => y_max,
      'xLabel' => x_label,
      'xUnits' => x_unit ? x_unit.name : nil,
      'xMin' => x_min,
      'xMax' => x_max,
      'yTicks' => y_ticks,
      'xTicks' => x_ticks,
      'predictionType' => prediction_type
    }
  end

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
