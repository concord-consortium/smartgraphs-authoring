class SensorGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title   :string, :required
    y_label :string, :required
    y_min   :float, :required
    y_max   :float, :required
    y_ticks :float, :required
    x_label :string, :required
    x_min   :float, :required
    x_max   :float, :required
    x_ticks :float, :required
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#sensor_graph_panes'

  has_many :annotation_inclusions, :as => :including_graph, :dependent => :destroy
  has_many :included_graphs, :through => :annotation_inclusions

  def field_order
    "title, y_label, y_unit, y_min, y_max, y_ticks, x_label, x_unit, x_min, x_max, x_ticks"
  end

  def to_hash
    hash = {
      'type' => 'SensorGraphPane',
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
      'xTicks' => x_ticks
    }
    if included_graphs.size > 0
      hash['includeAnnotationsFrom'] = included_graphs.map{|graph| graph.get_indexed_path }
    end
    return hash
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
