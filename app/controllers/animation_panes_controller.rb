class AnimationPanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :page, [ :index, :new, :create ]

  def destroy
  	animation_pane = AnimationPane.find params[:id]
    hobo_destroy :redirect => animation_pane.page
  end

  # This isn't saving the activity
  # def new
  #   hobo_create(AnimationPane.create(params[:animation_pane])) do
  #     hobo_ajax_response if request.xhr?
  #   end
  # end

  def new_for_page
    @animation_pane = AnimationPane.new
    if params[:page_path]
      params[:page_path] = CGI.unescape(params[:page_path])
    end
    if request.xhr? && !params[:animation_id].blank?
      @animation_pane.animation = Animation.find(params[:animation_id])
      hobo_ajax_response
    end
  end
end
