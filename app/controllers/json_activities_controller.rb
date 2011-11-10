require 'erb'

class JsonActivitiesController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def show
    hobo_show do |format|
      format.json {
        render :text => @json_activity.json
      }
      format.html {}
    end
  end

  show_action :preview do
    File.open "#{Rails.root}/public/smartgraphs-runtime.html" do |file|
      template = ERB.new file.read
      authored_activity_json = JsonActivity.find(params[:id]).json
      render :text => template.result(binding)
    end
  end
end
