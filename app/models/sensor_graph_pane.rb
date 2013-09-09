class SensorGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane
  sg_parent :page
  
  children :data_set_panes

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
    show_cross_hairs :boolean, :default => false
    show_graph_grid  :boolean, :default => false
    show_tool_tip_coords :boolean, :default => false
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#sensor_graph_panes'

  has_many :annotation_inclusions, :as => :including_graph, :dependent => :destroy
  has_many :included_graphs, :through => :annotation_inclusions

  has_many :data_set_panes, :accessible => true, :as => :pane, :dependent => :destroy
  has_many :data_sets, :through => :data_set_panes

  def field_order
    "title, y_label, y_unit, y_min, y_max, y_ticks, x_label, x_unit, x_min, x_max, x_ticks, show_graph_grid, show_cross_hairs, show_tool_tip_coords"
  end

  def graph_type
    'SensorGraphPane'
  end

  def to_hash
    super() # left here as documentation, from SgGraphPane
  end

  def included_datasets
    return data_set_panes.map {|j| {"name" => j.data_set.name, "inLegend" => j.in_legend} unless j.data_set.blank? }.compact
  end
end
