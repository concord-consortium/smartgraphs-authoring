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

  def preview
    File.open "#{Rails.root}/public/static/smartgraphs/en/82b404e9816653aae3437852c272301c88eb986a/index.html" do |file|
      render :text => file.read
    end
  end

end
