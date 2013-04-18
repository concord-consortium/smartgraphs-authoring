class EmptyPanesController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :page, [ :index, :new, :create ]

  def destroy
  	empty_pane = EmptyPane.find params[:id]
    hobo_destroy :redirect => empty_pane.page
  end

end
