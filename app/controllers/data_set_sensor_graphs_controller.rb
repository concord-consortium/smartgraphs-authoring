class DataSetSensorGraphsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :sensor_graph_pane, [:new, :create]
end
