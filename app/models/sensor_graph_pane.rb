class SensorGraphPane < ActiveRecord::Base

  hobo_model # Don't put anything above this
  
  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane
  sg_parent :page
  
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
    timestamps
  end

  belongs_to :y_unit, :class_name => 'Unit'
  belongs_to :x_unit, :class_name => 'Unit'

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#sensor_graph_panes'

  has_many :annotation_inclusions, :as => :including_graph, :dependent => :destroy
  has_many :included_graphs, :through => :annotation_inclusions

  has_many :data_sets, :through => :data_set_sensor_graphs, :accessible => true
  has_many :data_set_sensor_graphs, :dependent => :destroy

  def field_order
    "title, y_label, y_unit, y_min, y_max, y_ticks, x_label, x_unit, x_min, x_max, x_ticks"
  end

  def graph_type
    'SensorGraphPane'
  end

  def to_hash
    super() # left here as documentation, from SgGraphPane
  end

end
