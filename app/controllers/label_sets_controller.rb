class LabelSetsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :activity, [:new, :create]

  def destroy
  	labelSet = LabelSet.find params[:id]
    hobo_destroy :redirect => labelSet.activity
  end

end
