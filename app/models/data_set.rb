class DataSet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane

  sg_parent :activity

  LineType  = HoboFields::Types::EnumString.for(:connected, :none)
  PointType = HoboFields::Types::EnumString.for(:none, :dot)

  fields do
    name :string, :required
    y_precision :float, :default => 0.1
    x_precision :float, :default => 0.1
    line_snap_distance :float, :default => 0.1

    expression :string, :default =>"" #y = 0.5 * x + 5",
    
    # not sure if this belongs on graphPane or ?
    line_type  DataSet::LineType,   :default => "none"
    point_type DataSet::PointType,  :default => "dot"

    data :text
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  belongs_to :activity

  has_many :data_set_graphs, :dependent => :destroy
  has_many :predefined_graph_panes, :through => :data_set_graphs

  before_validation do
    normalize_data
    normalize_expression
  end

  validate :validate_expression

  def field_order
    fo  = %w[name expression line_snap_distance line_type point_type]
    fo << %w[data]
    fo.flatten.compact.join(", ") # silly hobo
  end

  def include_annotations_from_from_hash(graph_reference_urls)
    self_ref = self
    callback = Proc.new do
      self_ref.reload
      graphs = self_ref.sg_activity.pages.map { |p| [p.predefined_graph_panes,p.prediction_graph_panes,p.sensor_graph_panes]}
      graphs.flatten!
      graphs.select! { |g| (g.respond_to? :get_indexed_path) && (graph_reference_urls.include?(g.get_indexed_path))}
      graphs.each do |graph|
        self_ref.included_graphs << graph
      end
    end
    self.add_marshall_callback(callback)
  end

  def to_hash
    hash = {
      'type' => self.type,
      'name' => name,
      'yLabel' => y_label,
      'yUnits' => y_unit ? y_unit.name : nil,
      'xUnits' => x_unit ? x_unit.name : nil,
      'xMin' => x_min,
      'xMax' => x_max,
      'yTicks' => y_ticks,
      'xTicks' => x_ticks
    }
    if included_graphs.size > 0
      hash['includeAnnotationsFrom'] = included_graphs.map{|graph| graph.get_indexed_path }
    end
    hash
  end
    
  def x_units_from_hash(definition)
    self.x_unit = Unit.find_or_create_by_name(definition)
  end

  def y_units_from_hash(definition)
    self.y_unit = Unit.find_or_create_by_name(definition)
  end

  def data_from_hash(points)
    tmp_data  = points.map{ |point| point.join(",") }
    self.data = tmp_data.join("\n")
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

  # Validation must now support compound expressions..
  def validate_expression
    slope_regex = /^(\-?\d+\s*\*\s*)?x\s*([+|-]\s*\d+)?$/
    compound_regex = /^(sin|cos|tan|asin|acos|atan|pow|log|sqrt|X|x|\,|\.|\+|\-|\*|\/|\(|\)|\s|[0-9])+$/
    return if self.expression.empty?
    return if self.expression.match(slope_regex)
    return if self.expression.match(compound_regex)
    errors.add(:expression, "unkown expression format. Please use '[m] * x + [b]' for slope-form. You may also use sin cos, tan, asin, acos, atan, pow, log, sqrt")
  end

  def is_data_ref?
    return (!(self.expression.nil && self.expression.blank?))
  end

  def type
    return 'dataRef' if self.is_data_ref?
    return "dataDef"
  end

  ##
  ## create one or more datasets from
  def self.from_predefined_graph_pane(graph)
    # cache = {}
    # key = "#{graph.class_name}_#{graph.id}"
    # other method will cache.
    return unless (graph.page && graph.page.activity)
    activity = graph.page.activity
    column_names = self.column_names
    other_column_names = graph.class.column_names
    column_names.select! { |n| other_column_names.include?(n) }
    column_names.reject! { |n| n == "id" }
    attributes = graph.attributes
    attributes.select! { |k,v| column_names.include?(k)}
    new_item = self.new(attributes)
    new_item.activity = activity
    new_item.predefined_graph_panes << graph
    new_item.name = graph.title
    new_item.save!
    # TODO, other things.
  end

  def self.convertAllGraphPanes()
    PredefinedGraphPane.all.each do |gp|
      self.from_predefined_graph_pane(gp)
    end
  end

end