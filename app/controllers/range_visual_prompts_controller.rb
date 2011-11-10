class RangeVisualPromptsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  polymorphic_auto_actions_for :text_hint, [ :index, :new, :create ]

  polymorphic_auto_actions_for :initial_prompt_sequence, [ :index, :new, :create ]
  polymorphic_auto_actions_for :give_up_sequence, [ :index, :new, :create ]
  polymorphic_auto_actions_for :confirm_correct_sequence, [ :index, :new, :create ]
end
