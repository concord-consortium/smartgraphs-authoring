class RangeVisualPromptsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :text_hint, [ :index, :new, :create ]

end
