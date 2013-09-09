class LinkedAnimationPane < ActiveRecord::Base

  hobo_model # Don't put anything above this

  view_hints.parent :page

  # standard owner and admin permissions
  # defined in models/standard_permissions.rb
  include SgPermissions
  include SgMarshal
  include SgGraphPane

  sg_parent :page

  fields do
    title :string, :required

    x_label :string, :required
    x_min :float, :required
    x_max :float, :required
    x_ticks :float, :required
    x_precision :float, :default => 0.1

    y_label :string, :required
    y_min :float, :required
    y_max :float, :required
    y_ticks :float, :required
    y_precision :float, :default => 0.1

    show_cross_hairs :boolean, :default => false
    show_graph_grid  :boolean, :default => false
    show_tool_tip_coords :boolean, :default => false

    timestamps
  end

  has_one :page_pane, :as => :pane, :dependent => :destroy
  has_one :page, :through => :page_pane

  reverse_association_of :page, 'Page#linked_animation_panes'

  has_many :data_set_panes, :accessible => true, :as => :pane, :dependent => :destroy
  has_many :data_sets, :through => :data_set_panes

  has_many :label_set_graph_panes, :accessible => true, :as => :pane, :dependent => :destroy
  has_many :label_sets, :through => :label_set_graph_panes

  def field_order
    "title, x_label, x_min, x_max, x_ticks, x_precision, y_label, y_min, y_max, y_ticks, y_precision, show_cross_hairs, show_graph_grid, show_tool_tip_coords"
  end

  def graph_type
    'LinkedAnimationPane'
  end

  def included_datasets
    return data_set_panes.map {|j| {"name" => j.data_set.name, "inLegend" => j.in_legend} unless j.data_set.blank? }.compact
  end
end
