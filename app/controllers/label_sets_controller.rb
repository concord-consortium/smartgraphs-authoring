class LabelSetsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :activity, [:new, :create]

end
