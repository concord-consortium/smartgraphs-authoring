class PredictionGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane
  sg_parent :page
  
  children :data_set_prediction_graphs

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
    show_cross_hairs :boolean, :default => false
    show_graph_grid  :boolean, :default => false
    show_tool_tip_coords :boolean, :default => false
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

  has_many :data_sets, :through => :data_set_prediction_graphs
  has_many :data_set_prediction_graphs, :accessible => true, :dependent => :destroy

  def field_order
    "title, y_label, y_unit, y_min, y_max, y_ticks, y_precision, x_label, x_unit, x_min, x_max, x_ticks, x_precision, prediction_type, show_graph_grid, show_cross_hairs, show_tool_tip_coords"
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

  def included_datasets
    return data_set_prediction_graphs.map {|j| {"name" => j.data_set.name, "inLegend" => j.in_legend} }
  end

  def self.get_all_graph_panes_before(pane)
    return [] unless is_graph_pane?(pane)

    pane_collection = []

    page = pane.page
    activity = page.activity

    # iterate through all the pages and panes until we encounter the passed in pane.
    # Then return all the graph panes we've encountered up until that point.
    activity.pages.each do |pg|
      pg.page_panes.each do |pn|
        if pn.pane == pane
          return pane_collection
        else
          pane_collection << pn.pane if is_graph_pane?(pn.pane)
        end
      end
      return pane_collection if pg == page
    end
    return pane_collection
  end

  def self.get_all_prediction_graph_panes_before(pane)
    panes = get_all_graph_panes_before(pane)
    return panes.select{|p| p.kind_of?(PredictionGraphPane) }
  end

  def self.is_graph_pane?(pane)
    return pane.kind_of?(SensorGraphPane) || pane.kind_of?(PredictionGraphPane) || pane.kind_of?(PredefinedGraphPane)
  end
end
