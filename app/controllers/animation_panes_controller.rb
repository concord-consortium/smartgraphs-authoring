class AnimationPanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :page, [ :index, :new, :create ]

  def destroy
  	animation_pane = AnimationPane.find params[:id]
    hobo_destroy :redirect => animation_pane.page
  end

  def edit
    hobo_edit do
      this.attributes = params[:animation_pane] || {}
      hobo_ajax_response if request.xhr?
    end
  end

  def new
    hobo_new do
      this.attributes = params[:animation_pane] || {}
      hobo_ajax_response if request.xhr?
    end
  end

  def new_for_page
    hobo_new_for :page do
      this.attributes = params[:animation_pane] || {}
      hobo_ajax_response if request.xhr?
    end
  end
end
