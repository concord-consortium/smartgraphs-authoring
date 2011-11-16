class ConstructedResponsesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :constructed_response_sequence, [:new, :create]

end
