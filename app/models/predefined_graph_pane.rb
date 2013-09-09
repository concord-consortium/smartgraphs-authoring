class PredefinedGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  view_hints.parent :page

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane

  sg_parent :page

  children :data_set_panes
  # children  :data_set_graphs, :data_sets

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

    show_cross_hairs :boolean, :default => false
    show_graph_grid  :boolean, :default => false
    show_tool_tip_coords :boolean, :default => false

    # Keep these fields around to migrate older data,
    # even though data_set.rb now provides this kind of
    # data.  See DataSet#from_predefined_graph_pane
    expression :string, :default =>"" #y = 0.5 * x + 5",
    line_snap_distance :float, :default => 0.1
    line_type  SgGraphPane::LineType,   :default => "none"
    point_type SgGraphPane::PointType,  :default => "dot"
    data :text
    # end of LegacyFields

    timestamps
  end

  # legacy associations
  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'
  # end

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#predefined_graph_panes'

  has_many :annotation_inclusions, :as => :including_graph, :dependent => :destroy
  has_many :included_graphs, :through => :annotation_inclusions

  has_many :data_set_panes, :accessible => true, :as => :pane, :dependent => :destroy
  has_many :data_sets, :through => :data_set_panes

  has_many :label_sets, :through => :label_set_predefined_graphs
  has_many :label_set_predefined_graphs, :accessible => true, :dependent => :destroy

  belongs_to :animation

  has_many :graph_labels, :accessible => true, :conditions => { :label_set_id => nil }

  def field_order
    fo  = %w[title x_label x_min x_max x_ticks ]
    fo << %w[y_label y_min y_max y_ticks]
    fo << %w[show_graph_grid show_tool_tip_coords]
    fo.flatten.compact.join(", ") # silly hobo
  end

  def graph_type
    'PredefinedGraphPane'
  end

  def included_datasets
    return data_set_panes.map {|j| {"name" => j.data_set.name, "inLegend" => j.in_legend} unless j.data_set.blank? }.compact
  end
end
