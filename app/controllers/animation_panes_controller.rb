class AnimationPanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :page, [ :index, :new, :create ]

  def destroy
  	animation_pane = AnimationPane.find params[:id]
    hobo_destroy :redirect => animation_pane.page
  end

end
