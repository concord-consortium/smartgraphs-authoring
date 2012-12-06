class PredefinedGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane

  sg_parent :page
  
  children :data_sets
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

    # Keep these fields around to migrate older data, 
    # even though data_set.rb now provides this kind of
    # data.  See DataSet#from_predefined_graph_pane
    expression :string, :default =>"" #y = 0.5 * x + 5",
    line_snap_distance :float, :default => 0.1
    line_type  SgGraphPane::LineType,   :default => "none"
    point_type SgGraphPane::PointType,  :default => "dot"
    show_cross_hairs :boolean, :default => false
    show_graph_grid  :boolean, :default => false
    show_tool_tip_coords :boolean, :default => false
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

  has_many :data_sets, :through => :data_set_graphs, :accessible => true
  has_many :data_set_graphs, :dependent => :destroy
  

  def field_order
    fo  = %w[title y_label y_min y_max y_ticks ]
    fo << %w[x_label x_min x_max x_ticks ]
    fo << %w[show_graph_grid show_cross_hairs show_tool_tip_coords]
    fo.flatten.compact.join(", ") # silly hobo
  end

  def graph_type
    'PredefinedGraphPane'
  end

  def included_data_sets_from_hash(definitions)
    callback = Proc.new do
      self.reload
      definitions.each do |definition|
        found_data_set = self.page.activity.data_sets.find_by_name(definition['name'])
        self.data_sets << found_data_set
      end
      self.save!
    end
    self.add_marshall_callback(callback)
  end

  def to_hash
    hash = super()
    hash["showCrossHairs"] = show_cross_hairs
    hash["showToolTipCoords"] = show_tool_tip_coords
    hash["showGraphGrid"] = show_graph_grid
    hash["includedDataSets"] = included_datasets
    return hash
  end

  def included_datasets
    # TODO: Eventually we want to be able to specify if datasets are
    # in the legend.
    return data_sets.map {|d| {"name" => d.name, "inLegend" => true} }
  end

end
