class DataSetsController < ApplicationController

  hobo_model_controller

  auto_actions :all, :except => :index
  auto_actions_for :activity, [:new, :create]


  def destroy
    hobo_destroy do
      redirect_to activity_url(@data_set.activity)
    end
  end
end
