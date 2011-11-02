class PredefinedGraphPanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :page, [ :index, :new, :create ]

  def new_for_page
    id = params["page_id"]
    owner = Page.find(id)
    new_pane = owner.predefined_graph_panes.new
    new_pane.page = owner
    hobo_new_for :page, new_pane
  end

  def create_for_page
    id = params["page_id"]
    owner = Page.find(id)
    attributes = attribute_parameters
    attributes[:page] = owner
    hobo_create_for :page, :attributes => attributes
  end
end
