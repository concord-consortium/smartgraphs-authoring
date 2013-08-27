class AnimationsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :activity, [:new, :create]

  def destroy
  	animation = Animation.find params[:id]
    hobo_destroy :redirect => animation.activity
  end

end
