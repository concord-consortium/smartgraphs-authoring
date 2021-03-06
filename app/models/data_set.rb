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

    piecewise_linear :boolean, :default => false

    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  belongs_to :activity

  has_many :data_set_panes, :dependent => :destroy

  has_many :predefined_graph_panes, :through => :data_set_panes, :source => :pane, :source_type => 'PredefinedGraphPane'
  reverse_association_of :predefined_graph_panes, 'PredefinedGraphPane#data_sets'

  has_many :linked_animation_panes, :through => :data_set_panes, :source => :pane, :source_type => 'LinkedAnimationPane'
  reverse_association_of :linked_animation_panes, 'LinkedAnimationPane#data_sets'

  has_many :sensor_graph_panes, :through => :data_set_panes, :source => :pane, :source_type => 'SensorGraphPane'
  reverse_association_of :sensor_graph_panes, 'SensorGraphPane#data_sets'

  has_many :prediction_graph_panes, :through => :data_set_panes, :source => :pane, :source_type => 'PredictionGraphPane'
  reverse_association_of :prediction_graph_panes, 'PredictionGraphPane#data_sets'

  belongs_to :derivative_of, :inverse_of => :derivative, :class_name => 'DataSet'
  has_one :derivative, :inverse_of => :derivative_of, :class_name => 'DataSet'

  before_validation do
    reformat_data_text
    reformat_expression
  end

  validate :validate_expression

  def field_order
    "name, expression, derivative_of, piecewise_linear, line_snap_distance, line_type, point_type, data, x_unit, y_unit, x_precision, y_precision"
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
      'expression'       => expression_to_hash,
      'derivativeOf'     => derivative_of ? derivative_of.name : nil,
      'piecewiseLinear'  => derivative_of ? piecewise_linear? : nil
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

  def derivative_of_from_hash(definition)
    if definition
      self_ref = self
      callback = Proc.new do
        self_ref.reload
        # HACK. We can't find this activity's datasets because the activity
        # itself isn't yet valid; the callback happens after the DataSets are created
        # but before the Activity. (ugh)
        # So we count on the last DataSet created by this name being the one just created
        # in this copy and therefore the local one.
        self_ref.derivative_of = DataSet.find_all_by_name(definition).last
        self_ref.save!
      end
      self.add_marshal_callback(callback)
    else
      self.derivative_of = nil
    end
  end

  def expression_to_hash
    if expression.empty?
      return ""
    else
      e = expression.gsub(/^\s*y\s*=\s*/,"")
      return "y = #{e}"
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

  def self.derivatives_by_activity(activity)
    where("activity_id = ? AND derivative_of_id IS NOT NULL", activity.id)
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
