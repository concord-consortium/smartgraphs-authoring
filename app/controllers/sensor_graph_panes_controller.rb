class SensorGraphPanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :page, [ :index, :new, :create ]

  def create
    included_graphs = params[:sensor_graph_pane].delete(:included_graphs)

    hobo_create

    @sensor_graph_pane.included_graphs = get_included_graphs(included_graphs)
  end

  alias :old_create_for_page :create_for_page
  def create_for_page
    included_graphs = params[:sensor_graph_pane].delete(:included_graphs)

    old_create_for_page

    @sensor_graph_pane.included_graphs = get_included_graphs(included_graphs)
  end

  def update
    included_graphs = params[:sensor_graph_pane].delete(:included_graphs)

    hobo_update

    @sensor_graph_pane.included_graphs = get_included_graphs(included_graphs)
  end

end
