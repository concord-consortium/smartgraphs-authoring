class Admin::UsersController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    hobo_index do |format|
      format.csv { render :text => ::User.weigh_anchor.maroon } # Uses csv_pirate to create a CSV serialization
      format.html
    end
  end

end
