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

  def preview
    File.open "#{Rails.root}/public/static/smartgraphs/en/5a2301d099b8d537c51560051dd2bc99eb4b582f/index.html" do |file|
      template = ERB.new file.read
      authored_activity_json = JsonActivity.find(params[:id]).json
      render :text => template.result(binding)
    end
  end
end
