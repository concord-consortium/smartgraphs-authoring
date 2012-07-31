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

  def field_order
    "title, y_label, y_unit, y_min, y_max, y_ticks, y_precision, x_label, x_unit, x_min, x_max, x_ticks, x_precision, data"
  end

  def to_hash
    hash = {
      'type' => 'PredefinedGraphPane',
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
      'yPrecision' => y_precision,
      'xTicks' => x_ticks,
      'xPrecision' => x_precision,
      'data' => data.split("\n").map {|point| point.split(',').map{|value| value.to_f}}
    }
    if included_graphs.size > 0
      hash['includeAnnotationsFrom'] = included_graphs.map{|graph| graph.get_indexed_path }
    end
    return hash
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


end
