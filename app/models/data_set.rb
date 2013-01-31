class DataSet < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal

  sg_parent :activity

  LineType  = HoboFields::Types::EnumString.for(:connected, :none)
  PointType = HoboFields::Types::EnumString.for(:none, :dot)

  fields do
    name :string, :required
    y_precision :float, :default => 0.1
    x_precision :float, :default => 0.1
    line_snap_distance :float, :default => 0.1

    expression :string, :default =>"" #y = 0.5 * x + 5",

    line_type  DataSet::LineType,   :default => "none"
    point_type DataSet::PointType,  :default => "dot"

    data :text
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  belongs_to :activity

  has_many :data_set_predefined_graphs, :dependent => :destroy
  has_many :predefined_graph_panes, :through => :data_set_predefined_graphs

  has_many :data_set_sensor_graphs, :dependent => :destroy
  has_many :sensor_graph_panes, :through => :data_set_sensor_graphs

  has_many :data_set_prediction_graphs, :dependent => :destroy
  has_many :prediction_graph_panes, :through => :data_set_prediction_graphs

  before_validation do
    reformat_data_text
    reformat_expression
  end

  validate :validate_expression

  def field_order
    "name, expression, line_snap_distance, line_type, point_type, data, x_unit, y_unit, x_precision, y_precision"
  end

  def to_hash
    hash = {
      'type'             => self.type,
      'name'             => self.name,
      'yUnits'           => y_unit ? y_unit.name : nil,
      'xUnits'           => x_unit ? x_unit.name : nil,
      'xPrecision'       => x_precision,
      'yPrecision'       => y_precision,
      'lineSnapDistance' => line_snap_distance,
      'lineType'         => line_type,
      'pointType'        => point_type,
      'data'             => data_to_hash,
      'expression'       => expression_to_hash
    }
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
    reformat_data_text
    data.split("\n").map {|point| point.split(',').map{|value| value.to_f}}
  end

  def reformat_data_text
    self.data ||= ""
    points = self.data.strip.split("\n").map {|point| point.strip }
    points.map! {|point| point.split(/\s*[,\t]\s*/)}
    self.data = points.map! { |point| point.join(',')}.join("\n")
  end

  def reformat_expression
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
    return !self.expression.nil? && !self.expression.blank?
  end

  def type
    return 'dataref' if self.is_data_ref?
    return 'datadef'
  end

  ##
  ## create one or more datasets from
  ## a PredefinedGraphPane or a PredictionGraphPane
  def self.from_graph_pane(graph)
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
    if graph.is_a?(PredefinedGraphPane)
      new_item.predefined_graph_panes << graph
    elsif graph.is_a?(PredictionGraphPane)
      new_item.prediction_graph_panes << graph
    elsif graph.is_a?(SensorGraphPane)
      new_item.sensor_graph_panes << graph
    end
    new_item.name = "#{graph.title.parameterize}-#{activity.data_sets.length+1}"
    new_item.save!
    # TODO, other things.
  end

  def self.convertAllGraphPanes()
    PredefinedGraphPane.all.each do |gp|
      self.from_graph_pane(gp)
    end
    PredictionGraphPane.all.each do |pp|
      self.from_graph_pane(pp)
    end
    SensorGraphPane.all.each do |sp|
      self.from_graph_pane(sp)
    end
  end

end
