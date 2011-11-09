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
    File.open "#{Rails.root}/public/static/smartgraphs/en/4b16f9339305b3d2916641c6012a3a41df4c0874/index.html" do |file|
      template = ERB.new file.read
      authored_activity_json = JsonActivity.find(params[:id]).json
      render :text => template.result(binding)
    end
  end
end
