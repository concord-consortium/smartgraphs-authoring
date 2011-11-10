class TextHintsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :pick_a_point_sequence, [ :index, :new, :create ]
  polymorphic_auto_actions_for :numeric_sequence, [ :index, :new, :create ]

end
