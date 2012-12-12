class PredictionGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane
  sg_parent :page
  
  fields do
    title   :string
    y_label :string
    y_min   :float
    y_max   :float
    y_ticks :float
    y_precision :float, :default => 0.1
    x_label :string
    x_min   :float
    x_max   :float
    x_ticks :float
    x_precision :float, :default => 0.1
    prediction_type  enum_string(:connecting_points, :continuous_curves)
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#prediction_graph_panes'

  has_many :including_annotations, :class_name => 'AnnotationInclusion', :foreign_key => "included_graph_id", :dependent => :destroy
  has_many :including_graphs, :through => :including_annotations

  has_many :annotation_inclusions, :as => :including_graph, :dependent => :destroy
  has_many :included_graphs, :through => :annotation_inclusions

  has_many :data_sets, :through => :data_set_prediction_graphs, :accessible => true
  has_many :data_set_prediction_graphs, :dependent => :destroy

  def field_order
    "title, y_label, y_unit, y_min, y_max, y_ticks, y_precision, x_label, x_unit, x_min, x_max, x_ticks, x_precision, prediction_type"
  end

  def graph_type
    'PredictionGraphPane'
  end

  def to_hash
    hash = super(); # from SgGraphPane
    hash['xPrecision'] = x_precision
    hash['yPrecision'] = y_precision
    hash['predictionType'] = prediction_type
    return hash
  end
end
