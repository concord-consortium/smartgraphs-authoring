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

  # returns a 1-based indexed path string
  # eg page/2/pane/1
  def get_indexed_path
    page.activity.pages.each_with_index do |pg,pg_i|
      pg.page_panes.each_with_index do |pg_pn, pn_i|
        pn = pg_pn.pane
        if pn == self
          return "page/#{pg_i+1}/pane/#{pn_i+1}"
        end
      end
    end
    return nil
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
