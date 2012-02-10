class MultipleChoiceHintsController < ApplicationController

  hobo_model_controller

  auto_actions :write_only
  auto_actions_for :multiple_choice_sequence, :create


end
