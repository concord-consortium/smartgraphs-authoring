class ActivitiesController < ApplicationController

  hobo_model_controller

  auto_actions :all
  
  def show
    hobo_show do |format|
      format.json {
        render :text => @activity.to_hash.to_json
      }
      format.yaml {
        render :text => @activity.to_hash.to_yaml
      }
      format.html {}
    end
  end

end
