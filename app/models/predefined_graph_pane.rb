class PredefinedGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    title :string
    y_label :string
    # need to add y units
    y_min :float
    y_max :float
    y_ticks :float
    x_label :string
    # need to add x units
    x_min :float
    x_max :float
    x_ticks :float

    data :text
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#predefined_graph_panes'

  def to_hash
    {
      'type' => 'PredefinedGraphPane',
      'title' => title,
      'yLabel' => y_label,
      'yUnits' => y_unit.name,
      'yMin' => y_min,
      'yMax' => y_max,
      'xLabel' => x_label,
      'xUnits' => x_unit.name,
      'xMin' => x_min,
      'xMax' => x_max,
      'data' => data.split("\n").map {|point| point.split(',').map{|value| value.to_f}}
    }
  end

  before_validation do
    normalize_data
  end

  def normalize_data
    return unless self.data
    points = self.data.strip.split("\n").map {|point| point.strip }
    points.map! {|point| point.split(/\s*[,\t]\s*/)}
    self.data = points.map! { |point| point.join(',')}.join("\n")
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
