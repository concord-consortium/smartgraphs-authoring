class DataSetPanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  # auto_actions_for :predefined_graph_pane, [:new, :create]
end
