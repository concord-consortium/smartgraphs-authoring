class AnimationPanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :page, [ :index, :new, :create ]

  def destroy
  	animation_pane = AnimationPane.find params[:id]
    hobo_destroy :redirect => animation_pane.page
  end

  def edit
    self.this = AnimationPane.new(params[:animation_pane]) if params[:animation_pane]
    hobo_show do
      @animation_pane = this
      hobo_ajax_response if request.xhr?
    end
  end

  # This isn't saving the activity
  def new
    hobo_create(AnimationPane.create(params[:animation_pane])) do
      hobo_ajax_response if request.xhr?
    end
  end
end
