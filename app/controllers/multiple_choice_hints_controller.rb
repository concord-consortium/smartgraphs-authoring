class MultipleChoiceHintsController < ApplicationController

  hobo_model_controller

  auto_actions :all
  auto_actions_for :multiple_choice_sequence, :create

  # The default method created by
  # auto_actions_for  was redirecting to "/"
  # (probably an edge-case bug for mutliple child associations)
  #
  def create_for_multiple_choice_sequence
    hobo_create do
      page_path = params["page_path"]
      redirect_to  page_path if page_path && valid?
    end
  end

end
