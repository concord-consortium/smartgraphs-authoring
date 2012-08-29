class PredefinedGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane

  sg_parent :page

  fields do
    title :string, :required

    y_label :string, :required
    y_min :float, :required
    y_max :float, :required
    y_ticks :float, :required
    y_precision :float, :default => 0.1

    x_label :string, :required
    x_min :float, :required
    x_max :float, :required
    x_ticks :float, :required
    x_precision :float, :default => 0.1

    expression :string, :default =>"" #y = 0.5 * x + 5",
    line_snap_distance :float, :default => 0.1
    line_type  SgGraphPane::LineType,   :default => "none"
    point_type SgGraphPane::PointType,  :default => "dot"
    show_cross_hairs :boolean, :default => false
    show_graph_grid  :boolean, :default => false
    show_tool_tip_coords :boolean, :default => false
    data :text
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#predefined_graph_panes'

  has_many :annotation_inclusions, :as => :including_graph, :dependent => :destroy
  has_many :included_graphs, :through => :annotation_inclusions

  before_validation do
    normalize_data
    normalize_expression
  end

  validate :validate_expression

  def field_order
    fo  = %w[title y_label y_unit y_min y_max y_ticks y_precision]
    fo << %w[x_label x_unit x_min x_max x_ticks x_precision]
    fo << %w[show_graph_grid show_cross_hairs show_tool_tip_coords]
    fo << %w[expression line_snap_distance line_type point_type]
    fo << %w[data]
    fo.flatten.compact.join(", ") # silly hobo

  end

  def graph_type
    'PredefinedGraphPane'
  end

  def to_hash
    hash = super()
    hash['xPrecision'] = x_precision
    hash['yPrecision'] = y_precision
    hash['xPrecision'] = x_precision
    hash['data']       = data_to_hash
    hash["expression"] = expression_to_hash
    hash["lineSnapDistance"] = line_snap_distance
    hash["lineType"] = line_type
    hash["pointType"] = point_type
    hash["showCrossHairs"] = show_cross_hairs
    hash["showToolTipCoords"] = show_tool_tip_coords
    hash["showGraphGrid"] = show_graph_grid
    return hash
  end

  def expression_to_hash
    if expression.empty?
      return ""
    else
      return "y  = #{expression}"
    end
  end
  def data_to_hash
    normalize_data
    data.split("\n").map {|point| point.split(',').map{|value| value.to_f}}
  end

  def normalize_data
    self.data ||= ""
    points = self.data.strip.split("\n").map {|point| point.strip }
    points.map! {|point| point.split(/\s*[,\t]\s*/)}
    self.data = points.map! { |point| point.join(',')}.join("\n")
  end

  def normalize_expression
    self.expression.gsub!(/^\s*y\s*=\s*/,"")
  end

  def validate_expression
    slope_regex = /^(\-?\d+\s*\*\s*)?x\s*([+|-]\s*\d+)?$/
    return if self.expression.empty?
    return if self.expression.match(slope_regex)
    errors.add(:expression, "unkown expression format. Please use 'm * x + b'")
  end

end
